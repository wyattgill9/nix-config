let
  zen = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgzuLPAnG9sfhfoz2tj7sdcdPparwW+kI+mUiNeCJPj root@zen";
  wyatt = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAUNWNgYOg3y2uo+FTRYlyWapbcfl4yjspm02bYC/3Rs wyattgill01@outlook.com";
in {
  "tailscale-authkey.age".publicKeys = [
    zen
    wyatt
  ];

  "user-password.age".publicKeys = [
    zen
    wyatt
  ];
}
