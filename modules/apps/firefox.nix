# ── modules/apps/firefox.nix ────────────────────────────────────────────────
# Firefox, system-wide. Everything is applied through enterprise policies
# (/etc/firefox/policies/policies.json), so it works for any profile and needs
# no Home Manager profile management. Check about:policies after a rebuild.
{ ... }:
{
  programs.firefox = {
    enable = true;

    # ── Policies: enforced rules (users can't override "Locked" ones) ────────
    policies = {
      # Privacy: no telemetry, no experiments pushed from Mozilla.
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisableRemoteImprovements = true;

      OfferToSaveLogins = false; # Bitwarden handles passwords
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;

      # Do not remember search and form entries.
      DisableFormHistory = true;

      # DuckDuckGo is the default search engine.
      SearchEngines = {
        Default = "DuckDuckGo";
      };

      # These bookmarks are available as address-bar suggestions when typing.
      # They are not shown as homepage shortcuts (TopSites is disabled below).
      Bookmarks = [
        { Title = "Proton Mail"; URL = "https://mail.proton.me"; Placement = "menu"; }
        { Title = "ChatGPT"; URL = "https://chatgpt.com"; Placement = "menu"; }
        { Title = "YouTube"; URL = "https://www.youtube.com"; Placement = "menu"; }
        { Title = "Facebook"; URL = "https://www.facebook.com"; Placement = "menu"; }
        { Title = "Reddit"; URL = "https://www.reddit.com"; Placement = "menu"; }
      ];

      # Clean new-tab page: no shortcuts, no sponsored content.
      FirefoxHome = {
        Search = true; # Keep the search box on the new-tab homepage.
        TopSites = false; # Do not show bookmarks/sites as homepage shortcuts.
        SponsoredTopSites = false;
        SponsoredStories = false;
        Locked = true;
      };

      # Turn off Firefox's built-in AI features.
      # Remove "Translations" if you want built-in page translation back.
      AIControls = {
        Default = { Value = "blocked"; Locked = true; };
        Translations = { Value = "blocked"; Locked = true; };
        PDFAltText = { Value = "blocked"; Locked = true; };
        SmartTabGroups = { Value = "blocked"; Locked = true; };
        LinkPreviewKeyPoints = { Value = "blocked"; Locked = true; };
        SidebarChatbot = { Value = "blocked"; Locked = true; };
        SmartWindow = { Value = "blocked"; Locked = true; };
        SpeechRecognition = { Value = "blocked"; Locked = true; };
      };

      # Extensions installed automatically on first launch (the long ID is the
      # add-on's internal identifier; find yours at about:support -> Extensions).
      ExtensionSettings = {
        # Bitwarden
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
        
        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };

    # ── about:config defaults ───────────────────────────────────────────────
    # "default" = starting values you can still change;
    # use "locked" to force them.
    preferencesStatus = "default";
    preferences = {
      "browser.toolbars.bookmarks.visibility" = "never"; # hide the bookmarks bar

      # Hardware video decode on the Intel GPU (see modules/hardware/graphics.nix).
      "media.ffmpeg.vaapi.enabled" = true;

      # New tab / address bar noise
      "browser.discovery.enabled" = false;
      "extensions.htmlaboutaddons.recommendations.enabled" = false;
      "extensions.getAddons.showPane" = false;
      "browser.newtabpage.activity-stream.showSponsored" = false;
      "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
      "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
      "browser.newtabpage.activity-stream.feeds.topsites" = false;
      "browser.newtabpage.activity-stream.showSearch" = true;

      # Address bar: keep bookmark matches only; disable all other suggestion
      # categories requested (history, open tabs, shortcuts, recent searches,
      # search engines and quick actions).
      "browser.urlbar.suggest.history" = false;
      "browser.urlbar.suggest.bookmark" = true;
      "browser.urlbar.suggest.openpage" = false;
      "browser.urlbar.suggest.recentsearches" = false;
      "browser.urlbar.suggest.searches" = false;
      "browser.urlbar.suggest.quickactions" = false;

      # Do not show the search query in the address bar after loading results.
      "browser.urlbar.showSearchTerms.enabled" = false;

      # Do not place search suggestions ahead of browsing-history results.
      "browser.urlbar.showSearchSuggestionsFirst" = false;

      "browser.urlbar.suggest.quicksuggest.sponsored" = false;
      "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
      "browser.urlbar.suggest.addons" = false;
      "browser.urlbar.suggest.pocket" = false;
      "browser.urlbar.suggest.topsites" = false;
      "browser.urlbar.suggest.trending" = false;
      "browser.urlbar.suggest.yelp" = false;

      # Crash reporting (the telemetry, studies, password and autofill
      # switches are already covered by the policies above)
      "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
      "browser.crashReports.unsubmittedCheck.enabled" = false;
      "browser.tabs.crashReporting.sendReport" = false;

      # No accidental back/forward on touchpad swipe
      "browser.gesture.swipe.left" = "";
      "browser.gesture.swipe.right" = "";
    };
  };
}
