{ self, config, ... }:
let
  name = "Mattias Evensson";
  email = "mattias@evensson.eu";
in
{
  age.secrets = {
    matte_password.file = "${self}/secrets/matte_password.age";
    matte_id_ed25519.file = "${self}/secrets/matte_id_ed25519.age";
    matte_id_ed25519.owner = "matte";
  };

  users.users.matte = {
    uid = 1000;
    passwordFile = config.age.secrets.matte_password.path;
    description = name;
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
}

