# ── System/apps/firefox.nix ────────────────────────────────────────────────
# Firefox, system-wide via NixOS and Mozilla enterprise policies.
#
# Personal desktop configuration:
# - Privacy-conscious defaults without aggressive hardening.
# - User-adjustable preferences (Status = "default").
# - Strict Enhanced Tracking Protection by default.
# - HTTPS-Only Mode enabled by default, but user can disable it.
# - Clear browsing and form history on exit; preserve cookies and sessions.
# - Bitwarden and uBlock Origin installed normally, not force-managed.
#
# After rebuilding, inspect about:policies and about:config.

{ ... }:
{
  programs.firefox = {
    enable = true;

    # ── Enterprise policies ────────────────────────────────────────────────
    # Avoid Locked = true so every setting stays user-adjustable.
    policies = {

      # ── Search engine ────────────────────────────────────────────────────
      SearchEngines = {
        Default = "DuckDuckGo";
      };

      # ── Bookmarks ────────────────────────────────────────────────────────
      Bookmarks = [
        {
          Title = "Proton Mail";
          URL = "https://mail.proton.me";
          Placement = "menu";
        }
        {
          Title = "ChatGPT";
          URL = "https://chatgpt.com";
          Placement = "menu";
        }
        {
          Title = "YouTube";
          URL = "https://www.youtube.com";
          Placement = "menu";
        }
        {
          Title = "Facebook";
          URL = "https://www.facebook.com";
          Placement = "menu";
        }
        {
          Title = "Reddit";
          URL = "https://www.reddit.com";
          Placement = "menu";
        }
      ];

      # ── Firefox Home ─────────────────────────────────────────────────────
      FirefoxHome = {
        Search = true;
        TopSites = false;
        SponsoredTopSites = false;
        SponsoredStories = false;
        Stories = false;
        Locked = false;
      };

      # ── HTTPS-Only Mode ──────────────────────────────────────────────────
      HttpsOnlyMode = "enabled";

      # ── Website permissions ──────────────────────────────────────────────
      Permissions = {
        Notifications = {
          BlockNewRequests = true;
          Locked = false;
        };
      };

      # ── Firefox AI features ──────────────────────────────────────────────
      # Verify these names in about:policies after rebuilding.
      AIControls = {
        Default = {
          Value = "blocked";
          Locked = false;
        };
        Translations = {
          Value = "blocked";
          Locked = false;
        };
        PDFAltText = {
          Value = "blocked";
          Locked = false;
        };
        SmartTabGroups = {
          Value = "blocked";
          Locked = false;
        };
        LinkPreviewKeyPoints = {
          Value = "blocked";
          Locked = false;
        };
        SidebarChatbot = {
          Value = "blocked";
          Locked = false;
        };
        SmartWindow = {
          Value = "blocked";
          Locked = false;
        };
        SpeechRecognition = {
          Value = "blocked";
          Locked = false;
        };
      };

      # ── Extensions ───────────────────────────────────────────────────────
      ExtensionSettings = {
        # Bitwarden
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url =
            "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "normal_installed";
        };

        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          install_url =
            "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "normal_installed";
        };
      };
    };

    # ── about:config preferences ───────────────────────────────────────────
    # Written as policy Preferences with Status = "default".
    preferencesStatus = "default";

    preferences = {

      # ── Privacy: Enhanced Tracking Protection ────────────────────────────
      "browser.contentblocking.category" = "strict";

      # ── Privacy: data submission ─────────────────────────────────────────
      "datareporting.policy.dataSubmissionEnabled" = false;

      # ── Password manager and autofill ────────────────────────────────────
      "signon.rememberSignons" = false;
      "extensions.formautofill.addresses.enabled" = false;
      "extensions.formautofill.creditCards.enabled" = false;
      "browser.formfill.enable" = true;

      # ── Touchpad gestures ────────────────────────────────────────────────
      # Empty values disable Firefox back/forward swipes, so GNOME's
      # workspace swipe doesn't navigate history.
      "browser.gesture.swipe.left" = "";
      "browser.gesture.swipe.right" = "";

      # ── File dialogs ─────────────────────────────────────────────────────
      "widget.use-xdg-desktop-portal.file-picker" = 1;

      # ── Hardware video decoding ──────────────────────────────────────────
      "media.ffmpeg.vaapi.enabled" = true;
      "media.av1.enabled" = false;

      # ── New tab and address-bar appearance ───────────────────────────────
      "browser.discovery.enabled" = false;
      "extensions.htmlaboutaddons.recommendations.enabled" = false;
      "extensions.getAddons.showPane" = false;

      "browser.newtabpage.activity-stream.showSponsored" = false;
      "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
      "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
      "browser.newtabpage.activity-stream.feeds.topsites" = false;
      "browser.newtabpage.activity-stream.showSearch" = true;

      # ── Address bar suggestions ──────────────────────────────────────────
      "browser.urlbar.suggest.history" = false;
      "browser.urlbar.suggest.bookmark" = true;
      "browser.urlbar.suggest.openpage" = false;
      "browser.urlbar.suggest.recentsearches" = false;
      "browser.urlbar.suggest.searches" = false;
      "browser.urlbar.suggest.quickactions" = false;
      "browser.urlbar.showSearchTerms.enabled" = false;
      "browser.urlbar.showSearchSuggestionsFirst" = false;
      "browser.urlbar.suggest.quicksuggest.sponsored" = false;
      "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
      "browser.urlbar.suggest.addons" = false;
      "browser.urlbar.suggest.pocket" = false;
      "browser.urlbar.suggest.topsites" = false;
      "browser.urlbar.suggest.trending" = false;
      "browser.urlbar.suggest.yelp" = false;

      # ── Crash reporting ──────────────────────────────────────────────────
      "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
      "browser.crashReports.unsubmittedCheck.enabled" = false;
      "browser.tabs.crashReporting.sendReport" = false;

      # ── Interface preferences ────────────────────────────────────────────
      "browser.toolbars.bookmarks.visibility" = "never";
    };

    # ── autoConfig: preferences that the policy engine rejects ─────────────
    # Written to defaults/pref, so they act as defaults the user can change.
    autoConfig = ''
      // Telemetry and studies
      pref("toolkit.telemetry.enabled", false);
      pref("datareporting.healthreport.uploadEnabled", false);
      pref("app.shield.optoutstudies.enabled", false);

      // Shutdown cleanup: clear history and form data, keep cookies and sessions
      pref("privacy.sanitize.sanitizeOnShutdown", true);
      pref("privacy.clearOnShutdown.history", true);
      pref("privacy.clearOnShutdown.formdata", true);
      pref("privacy.clearOnShutdown.cookies", false);
      pref("privacy.clearOnShutdown.sessions", false);
      pref("privacy.clearOnShutdown_v2.browsingHistoryAndDownloads", true);
      pref("privacy.clearOnShutdown_v2.formdata", true);
      pref("privacy.clearOnShutdown_v2.cookiesAndStorage", false);
    '';
  };
}

