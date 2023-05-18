{self, ...}: let
  name = "Mattias Evensson";
  email = "mattias@evensson.eu";
in {
  users.users.matte = {
    uid = 1000;
    #passwordFile = "/run/agenix/matte_password";
    description = name;
    isNormalUser = true;
    extraGroups = ["wheel"];
  };
}

