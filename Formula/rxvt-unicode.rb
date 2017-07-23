class RxvtUnicode < Formula
  desc "Rxvt fork with Unicode support"
  homepage "http://software.schmorp.de/pkg/rxvt-unicode.html"
  url "http://dist.schmorp.de/rxvt-unicode/rxvt-unicode-9.22.tar.bz2"
  sha256 "e94628e9bcfa0adb1115d83649f898d6edb4baced44f5d5b769c2eeb8b95addd"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "99a00bb5523cda0abb2a849e7af85cd8739526fea08231687b88724222b1aad7" => :sierra
    sha256 "a2b8cc310fa04d1ce66ffc0de2ea6591503cede49135e4b854e6267c837b5010" => :el_capitan
    sha256 "cdf8a97ab37a46eb605587b50eb7541be53866870241b85f202e92df2a67b8a8" => :yosemite
  end

  option "without-iso14755", "Disable ISO 14775 Shift+Ctrl hotkey"
  option "without-unicode3", "Disable 21-bit Unicode 3 (non-BMP) character support"

  deprecated_option "disable-iso14755" => "without-iso14755"

  depends_on "pkg-config" => :build
  depends_on :x11
	depends_on :perl => "5.18"

  # Patches 1 and 2 remove -arch flags for compiling perl support
  # Patch 3 fixes `make install` target on case-insensitive filesystems
  #patch :DATA

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-256-color
      --with-term=rxvt-unicode-256color
      --with-terminfo=/usr/share/terminfo
      --enable-smart-resize
    ]

    args << "--disable-perl" if ENV.compiler == :clang
    args << "--disable-iso14755" if build.without? "iso14755"
    args << "--enable-unicode3" if build.with? "unicode3"

    system "./configure", *args
    system "make", "install"
  end

  test do
    daemon = fork do
      system bin/"urxvtd"
    end
    sleep 2
    system bin/"urxvtc", "-k"
    Process.wait daemon
  end
end
