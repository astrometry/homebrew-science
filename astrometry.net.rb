require 'formula'

class AstrometryNet < Formula
  homepage 'http://astrometry.net'
  url 'http://astrometry.net/downloads/astrometry.net-0.40.tar.gz'
  sha1 '4f66b3c534f393b9613e47f6260f4996fd83f73d'

  head 'http://astrometry.net/svn/trunk/src/astrometry', :using => :svn

  depends_on 'wget'
  depends_on 'swig' => :build
  depends_on 'pkg-config' => :build
  depends_on 'netpbm'
  depends_on 'cairo'
  depends_on 'jpeg'
  depends_on 'libpng'

  # from pip
  depends_on 'pyfits' => :python

  depends_on 'wcslib'

  option 'without-extras', "Don't try to build plotting code (actually it will still try, but homebrew won't halt the install if it fails)"
  option 'without-py', "Don't try to build python code"

  def install
    ENV['INSTALL_DIR'] = "#{prefix}"
    ENV['NETPBM_INC'] = "-I#{HOMEBREW_PREFIX}/include/netpbm"
    ENV['NETPBM_LIB'] = "-L#{HOMEBREW_PREFIX}/lib -lnetpbm"

    mkdir_p "#{HOMEBREW_PREFIX}/lib/python"
    # Argh, should make Astrometry.net install python to lib/python

    system "make"
    if not build.include? 'without-extras'
      system "make extra"
    end
    if not build.include? 'without-py'
      system "make py"
    end
    system "make install"
  end

  def test
    system "solve-field"
  end
end
