module ConfigHelper

  def set_app_config
    @appConfig ||= {
      version:             Loomio::Version.current,
      showWelcomeModal:    !current_user_or_visitor.angular_ui_enabled?,
      reportErrors:        false,
      environment:         Rails.env,
      loadVideos:          (ENV.has_key?('LOOMIO_LOAD_VIDEOS') or Rails.env.production?),
      flash:               flash.to_h,
      currentUserId:       current_user_or_visitor.id,
      currentUserLocale:   current_user_or_visitor.locale,
      currentUserData:     CurrentUserData.new(current_user_or_visitor, user_is_restricted?).data,
      currentUrl:          request.original_url,
      canTranslate:        TranslationService.available?,
      permittedParams:     PermittedParamsSerializer.new({}),
      locales:             angular_locales,
      siteName:            ENV['SITE_NAME'] || 'Loomio',
      twitterHandle:       ENV['TWITTER_HANDLE'] || '@loomio',
      baseUrl:             root_url,
      safeThreadItemKinds: Discussion::THREAD_ITEM_KINDS,
      plugins:             Plugins::Repository.to_config,
      inlineTranslation: {
        isAvailable:       TranslationService.available?,
        supportedLangs:    Translation::SUPPORTED_LANGUAGES
      },
      pageSize: {
        default:           ENV['DEFAULT_PAGE_SIZE'] || 30,
        groupThreads:      ENV['GROUP_PAGE_SIZE'],
        threadItems:       ENV['THREAD_PAGE_SIZE'],
        exploreGroups:     ENV['EXPLORE_PAGE_SIZE'] || 10
      },
      flashTimeout: {
        short: (ENV['FLASH_TIMEOUT_SHORT'] || 3500).to_i,
        long:  (ENV['FLASH_TIMEOUT_LONG']  || 2147483645).to_i
      },
      drafts: {
        debounce: (ENV['LOOMIO_DRAFT_DEBOUNCE'] || 750).to_i
      },
      oauthProviders: [
        ({ name: :facebook, href: user_facebook_omniauth_authorize_path } if ENV['FACEBOOK_KEY']),
        ({ name: :twitter,  href: user_twitter_omniauth_authorize_path  } if ENV['TWITTER_KEY']),
        ({ name: :google,   href: user_google_omniauth_authorize_path   } if ENV['OMNI_CONTACTS_GOOGLE_KEY']),
        ({ name: :github,   href: user_github_omniauth_authorize_path   } if ENV['GITHUB_APP_ID'])
      ].compact
    }
  end
end