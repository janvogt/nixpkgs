{ lib
, stdenv
, fetchurl
, pkg-config
, glib
, libsoup
, gobject-introspection
, gnome
}:

stdenv.mkDerivation rec {
  pname = "rest";
  version = "0.9.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "hbK8k0ESgTlTm1PuU/BTMxC8ljkv1kWGOgQEELgevmY=";
  };

  nativeBuildInputs = [
    pkg-config
    gobject-introspection
  ];

  buildInputs = [
    glib
    libsoup
  ];

  configureFlags = [
    # Remove when https://gitlab.gnome.org/GNOME/librest/merge_requests/2 is merged.
    "--with-ca-certificates=/etc/ssl/certs/ca-certificates.crt"
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "librest";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Helper library for RESTful services";
    homepage = "https://wiki.gnome.org/Projects/Librest";
    license = licenses.lgpl21Only;
    platforms = platforms.unix;
    maintainers = teams.gnome.members;
  };
}
