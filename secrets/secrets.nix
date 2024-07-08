let
  ryzen = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKCK3vUzHDlEjCsIHmbNLcOruiFOBVjN8FatW1rFP4R1";
  t14g1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBFpE56AMvbwB8Wx9NanLIaMbfoNy8sYkrelVzBsCGEA";
  game = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIreCAf2sgG6Tr7LeieCta6E/vr87sh3Fec0vmpzFpzz";

  matte = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFK7dAPVafqqETZNEPwtzYVjzrR3pdEqhLSkwAF0J0rH";

  allKeys = [ ryzen t14g1 game matte ];
in
{
  "matte_password.age".publicKeys = allKeys;
  "matte_id_ed25519.age".publicKeys = allKeys;
  "test_password.age".publicKeys = allKeys;
}
