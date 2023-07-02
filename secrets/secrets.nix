let
  ryzen = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKCK3vUzHDlEjCsIHmbNLcOruiFOBVjN8FatW1rFP4R1";
  t14g1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBFpE56AMvbwB8Wx9NanLIaMbfoNy8sYkrelVzBsCGEA";

  matte = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFK7dAPVafqqETZNEPwtzYVjzrR3pdEqhLSkwAF0J0rH";

  allKeys = [ ryzen t14g1 matte ];
in
{
  "matte_password.age".publicKeys = allKeys;
  "matte_id_ed25519.age".publicKeys = allKeys;
}
