class SpiceClientGlib2 < Formula
  desc "Glib2 client/common libraries for SPICE"
  homepage "http://www.spice-space.org"
  url "https://www.spice-space.org/download/gtk/spice-gtk-0.35.tar.bz2"
  sha256 "b4e6073de5125e2bdecdf1fbe7c9e8c4cabe9c85518889b42f72bf63c8ab9e86"

  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext" => :build
  depends_on "json-glib" => :build

  depends_on "glib"
  depends_on "cairo"
  depends_on "jpeg"
  depends_on "openssl"
  depends_on "pixman"
  depends_on "spice-protocol"
  depends_on "usbredir"
  # TODO: audio

  patch do
    url "https://raw.githubusercontent.com/g3ngr33n/emergeless/master/net-misc/spice-gtk/files/0004-demarshallers-musl.patch"
    sha256 "85cc828a96735bdafcf29eb6291ca91bac846579bcef7308536e0c875d6c81d7"
  end
  
  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-gtk=no",
                          "--enable-vala=no",
                          "--with-audio=no",
                          "--disable-opus",
                          "--with-coroutine=gthread",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

