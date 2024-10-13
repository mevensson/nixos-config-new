{ config, ... }:
{
  programs.firefox = {
    enable = true;

    enableGnomeExtensions = true;

    policies = {
      DisablePocket = true;
      OfferToSaveLogins = false;
      Permissions = {
        Notifications = {
          BlockNewRequests = true;
        };
      };
    };

    profiles = {
      default = {
        isDefault = true;
        extensions = with config.nur.repos.rycee.firefox-addons; [
          lastpass-password-manager
          ublock-origin
        ]; 
        settings = {
          "services.sync.engine.addons" = false;
          "services.sync.engine.addresses" = false;
          "services.sync.engine.addresses.available" = false;
          "services.sync.engine.bookmarks" = true;
          "services.sync.engine.creditcards" = false;
          "services.sync.engine.creditcards.available" = false;
          "services.sync.engine.history" = true;
          "services.sync.engine.passwords" = false;
          "services.sync.engine.prefs" = false;
          "services.sync.engine.tabs" = true;
        };
      };
    };
  };
}
