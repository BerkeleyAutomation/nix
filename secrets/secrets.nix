let
  oliver = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGlViRB5HH1bTaS1S7TcqVBSuxKdrbdhL2CmhDqc/t6A";
  users = [ oliver ];

  bumblebee = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN1iq0eveXStUo2wqGMHEtvw41z0F7fwM13BXafjVxzc";
  hosts = [ bumblebee ];
in
{
  "cf-cert-creds.age".publicKeys = users ++ hosts;
}
