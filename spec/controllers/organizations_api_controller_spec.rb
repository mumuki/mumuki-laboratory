require 'spec_helper'

describe Api::OrganizationsController, type: :controller, organization_workspace: :base do
  def check_status!(status)
    expect(response.status).to eq status
  end

  describe 'unauthenticated request' do
    before { get :index }
    it { expect(response.body).to json_eq errors: ['missing authorization header'] }
    it { check_status! 401 }
  end

  describe 'invalid authenticated request' do
    before { set_token! 'foo' }
    before { get :index }
    it { expect(response.body).to json_eq errors: ['No Api Client found for Token'] }
    it { check_status! 401 }
  end

  describe 'authenticated request' do
    let(:book) { create :book }

    before { set_api_client! api_client }

    describe 'GET' do
      let!(:public_organization) { create :organization, name: 'public' }
      let!(:dot_organization) { create :organization, name: 'dot.org' }
      let!(:private_organization) { create :organization, name: 'private', public: false }
      let!(:another_private_organization) { create :organization, name: 'another_private', public: false }

      context 'GET /organizations' do
        let(:organization_names) { JSON.parse(response.body)['organizations'].map { |it| it['name'] }  }

        context 'with wildcard permissions' do
          before { get :index }
          let(:api_client) { create :api_client, role: :admin, grant: '*' }

          it { check_status! 200 }

          it { expect(organization_names).to contain_exactly 'base', 'public', 'dot.org', 'private', 'another_private' }
        end
        context 'with non-wildcard permissions' do
          before { get :index }
          let(:api_client) { create :api_client, role: :admin, grant: 'public/*:private/*' }

          it { check_status! 200 }

          it { expect(organization_names).to contain_exactly 'public', 'private' }
        end
      end

      context 'GET /organizations/:id' do
        context 'with a public organization' do
          before { get :show, params: {id: 'public'} }

          context 'with a user without admin permissions' do
            let(:api_client) { create :api_client, role: :editor, grant: 'another_organization/*' }

            it { check_status! 403 }
          end

          context 'with a user with admin' do
            let(:api_client) { create :api_client, role: :admin, grant: 'public/*' }

            it { check_status! 200 }
          end
        end

        context 'with an organization that has a dot in its name' do
          before { get :show, params: {id: 'dot.org'} }

          let(:api_client) { create :api_client, role: :admin, grant: 'dot.org/*' }
          it { check_status! 200 }
        end

        context 'with a private organization' do
          before { get :show, params: {id: 'private'} }

          context 'with a user without permissions' do
            let(:api_client) { create :api_client, role: :editor, grant: 'another_organization/*' }

            it { check_status! 403 }
          end

          context 'with a user with permissions' do
            let(:api_client) { create :api_client, role: :admin, grant: 'private/*' }

            it { check_status! 200 }
            it { expect(response.body).to json_like(private_organization.to_resource_h) }
          end
        end

        context 'with a non-existing organization' do
          before { get :show, params: {id: 'non-existing'} }
          let(:api_client) { create :api_client, role: :editor, grant: 'bleh/*' }

          it { check_status! 404 }
        end
      end
    end

    describe 'POST /organizations' do
      before { post :create, params: {organization: organization_json} }
      let(:organization_json) do
        {contact_email: 'an_email@gmail.com',
         name: 'a-name',
         public: false,
         book: book.slug,
         locale: 'es',
         time_zone: 'Buenos Aires'
        }
      end

      context 'with the admin permissions' do
        let(:api_client) { create :api_client, role: :admin, grant: '*' }
        let(:organization) { Organization.find_by name: 'a-name' }

        it { check_status! 200 }
        it { expect(response.body).to json_like(organization.to_resource_h) }
        it { expect(Organization.count).to eq 2 }
        it { expect(organization.name).to eq 'a-name' }
        it { expect(organization.contact_email).to eq 'an_email@gmail.com' }
        it { expect(organization.book).to eq book }
        it { expect(organization.locale).to eq 'es' }

        context 'with only mandatory values' do
          it { expect(organization.public?).to eq false }
          it { expect(organization.login_methods).to eq %w(user_pass) }
          it { expect(organization.logo_url).to eq 'https://mumuki.io/logo-alt-large.png' }
          it { expect(organization.theme_stylesheet).to eq '.defaultCssFromBase { css: red }' }
          it { expect(organization.extension_javascript).to eq 'function jsFromBase() {}' }
          it { expect(organization.terms_of_service).to eq nil }
        end

        context 'with optional values' do
          let(:organization_json) do
            {contact_email: 'an_email@gmail.com',
             name: 'a-name',
             description: 'A description',
             book: book.slug,
             locale: 'es',
             time_zone: 'Montevideo',
             public: false,
             login_methods: %w(facebook github),
             logo_url: 'http://a-logo-url.com',
             theme_stylesheet: '.theme { color: red }',
             extension_javascript: 'window.a = function() { }',
             terms_of_service: 'A TOS',
             faqs: 'some faqs'}
          end

          it { expect(organization.public?).to eq false }
          it { expect(organization.description).to eq 'A description' }
          it { expect(organization.login_methods).to eq %w(facebook github) }
          it { expect(organization.logo_url).to eq 'http://a-logo-url.com' }
          it { expect(organization.theme_stylesheet).to eq ".theme { color: red }" }
          it { expect(organization.extension_javascript).to eq "window.a = function() { }" }
          it { expect(organization.terms_of_service).to eq 'A TOS' }
          it { expect(organization.faqs).to eq 'some faqs' }
          it { expect(organization.time_zone).to eq 'Montevideo' }
        end

        context 'with missing values' do
          let(:organization_json) do
            {contact_email: 'an_email@gmail.com',
             locale: 'blabla'}
          end
          let(:expected_errors) do
            {
                errors: {
                    name: ["can't be blank"],
                    time_zone: ["can't be blank"],
                    locale: ['is not included in the list']
                }
            }
          end

          it { check_status! 400 }
          it { expect(response.body).to json_eq expected_errors }
        end
      end

      context 'with admin permissions' do
        let(:api_client) { create :api_client, role: :admin, grant: '*' }

        it { check_status! 200 }
      end


      context 'with non-admin permissions' do
        let(:api_client) { create :api_client, role: :editor, grant: '*' }

        it { check_status! 403 }
      end
    end

    describe 'PUT /organizations/:id' do
      let!(:organization) {
        create :organization,
                name: 'existing-organization',
                contact_email: 'first_email@gmail.com',
                terms_of_service: 'A TOS',
                public: false,
                login_methods: ['facebook', 'user_pass'],
                time_zone: 'UTC',
                book: book }
      let(:updated_organizaton) { organization.reload }
      let(:update_json) { {contact_email: 'second_email@gmail.com', immersive: true, locale: 'en'} }

      context 'with the admin permissions' do
        let(:api_client) { create :api_client, role: :admin, grant: 'existing-organization/*' }
        before { put :update, params: {id: organization.name, organization: update_json} }

        it { check_status! 200 }
        it { expect(response.body).to json_like(
                                            book: book.slug,
                                            name: "existing-organization",
                                            profile: {
                                              description: "a great org",
                                              locale: 'en',
                                              contact_email: "second_email@gmail.com",
                                              terms_of_service: 'A TOS',
                                              time_zone: 'UTC'
                                            },
                                            settings: {
                                              login_methods: ["facebook", "user_pass"],
                                              public: false,
                                              immersive: true
                                            },
                                            theme: {
                                              extension_javascript: 'function jsFromBase() {}',
                                              theme_stylesheet: '.defaultCssFromBase { css: red }'
                                            }) }

        it { expect(updated_organizaton.name).to eq 'existing-organization' }
        it { expect(updated_organizaton.contact_email).to eq 'second_email@gmail.com' }
      end

      context 'with janitor permissions' do
        let(:api_client) { create :api_client, role: :janitor, grant: 'existing-organization/*' }
        before { put :update, params: {id: 'existing-organization', organization: update_json} }

        it { check_status! 403 }
      end

      context 'with non-admin permissions' do
        let(:api_client) { create :api_client, role: :teacher, grant: 'existing-organization/*' }
        before { put :update, params: {id: 'existing-organization', organization: update_json} }

        it { check_status! 403 }
      end
    end
  end
end
