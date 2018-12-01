module LocaleHelper
  def locale_tags
    %Q{
      <script type="text/javascript">
        window.mumukiLocale = #{raw Organization.current.locale_json};
        mumuki.locale = '#{Organization.current.locale}';
        moment.locale('#{Organization.current.locale}');
      </script>
    }.html_safe
  end
end
