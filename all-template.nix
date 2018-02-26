self:
let
  callPackage = (import <nixpkgs> {{}}).newScope (self);
in
  {{
{spkgs}
  }}
