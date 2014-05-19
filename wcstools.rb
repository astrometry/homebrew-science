require 'formula'

# The wcstools-3.8.6 tarball seems to include a "Man" directory, and a
# "man -> Man" symlink.  On a typical cases-insensitive HFS+ Mac
# volume this causes trouble.  Tell "tar" not to extract the second
# "man".
class TarIgnoreDuplicates < CurlDownloadStrategy
  def stage
    safe_system '/usr/bin/tar', 'xkf', @tarball_path, '--exclude', '*/man'
    chdir
  end
end

class Wcstools < Formula
  homepage 'http://tdc-www.harvard.edu/wcstools/'
  url 'http://tdc-www.harvard.edu/software/wcstools/wcstools-3.8.6.tar.gz', :using => TarIgnoreDuplicates
  sha1 '2c42eb314d422ccd9c3f1999ac2642e9de480b4c'

  def install
    system "make all"
    # There doesn't seem to be a Makefile install target, so DIY.
    # Don't install the libwcs & libned includes directly in include/
    # because the "fitsfile.h" (and maybe others) conflict with
    # cfitsio.
    #d = Dir['bin/*'].find_all{|item| item[-5,5] != '.dSYM'}
    #print d
    #print
    #bin.install d
    bin.install Dir['bin/*'].find_all{|item| item[-5,5] != '.dSYM'}
    (lib + 'libwcs').install 'libwcs/libwcs.a'
    (lib + 'libned').install 'libned/libned.a'
    (include + 'libwcs').install Dir['libwcs/*.h']
    (include + 'libned').install Dir['libned/*.h']
    man1.install Dir['man/man1/*']
  end
end
