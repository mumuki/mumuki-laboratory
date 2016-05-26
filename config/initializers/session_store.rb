# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :cookie_store, key: '_mumuki_session', domain: {
                                                                                production: '.mumuki.io',
                                                                                development: '.localmumuki.io'
                                                                              }.fetch(Rails.env.to_sym, :all)
