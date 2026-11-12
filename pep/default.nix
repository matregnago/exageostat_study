{ pkgs ? import <nixpkgs> { }
  # Source of https://github.com/schnorr/infufrgs (pinned by flake.lock
  # when built through the flake).
, infufrgs ? builtins.fetchTarball "https://github.com/schnorr/infufrgs/archive/master.tar.gz"
}:

rec {
  emacs = pkgs.emacs-nox.pkgs.withPackages (epkgs: [ epkgs.org-ref ]);

  # infufrgs is not in TeX Live yet; expose the class via TEXINPUTS.
  # The trailing ':' keeps the default search path.
  texinputs = "${infufrgs}//:";

  pdf = pkgs.stdenv.mkDerivation {
    name = "infufrgs-paper";
    src = ./.;
    nativeBuildInputs = [ emacs pkgs.texliveFull ];
    TEXINPUTS = texinputs;
    buildPhase = ''
      export HOME=$TMPDIR
      emacs --batch --load export.el
      latexmk -pdf -interaction=nonstopmode -halt-on-error infufrgs.tex
    '';
    installPhase = ''
      mkdir -p $out
      cp infufrgs.pdf $out/
    '';
  };

  shell = pkgs.mkShell {
    packages = [ emacs pkgs.texliveFull ];
    TEXINPUTS = texinputs;
  };
}
