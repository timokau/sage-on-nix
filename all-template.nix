self:
let
  callPackage = (import <nixpkgs> {{}}).newScope (self);
in
  {{
    callPackage = callPackage;
{spkgs}
  }}
