let
  ryzen = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKCK3vUzHDlEjCsIHmbNLcOruiFOBVjN8FatW1rFP4R1";
  t14g1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBFpE56AMvbwB8Wx9NanLIaMbfoNy8sYkrelVzBsCGEA";
  game = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIreCAf2sgG6Tr7LeieCta6E/vr87sh3Fec0vmpzFpzz";
  live-installer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM1vsMKbfKe312SEwR6HKya7+k+4ToiJLxy9rujtD3ZV";

  matte = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFK7dAPVafqqETZNEPwtzYVjzrR3pdEqhLSkwAF0J0rH";

  allKeys = [ ryzen t14g1 game matte live-installer ];
in
{
  "matte_password.age".publicKeys = allKeys;
  "matte_id_ed25519.age".publicKeys = allKeys;
  "test_password.age".publicKeys = allKeys;
  "ryzen-cachix-deploy-agent.age".publicKeys = allKeys;
  "t14g1-cachix-deploy-agent.age".publicKeys = allKeys;
  "game-cachix-deploy-agent.age".publicKeys = allKeys;
  "luks-password.age".publicKeys = allKeys;
  "live-install-ssh-host-ed25519.age".publicKeys = allKeys;
}
