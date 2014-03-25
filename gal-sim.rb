require "formula"

class GalSim < Formula
  homepage "https://github.com/GalSim-developers/GalSim"
  url "https://github.com/GalSim-developers/GalSim/archive/v1.0.1.tar.gz"
  sha1 '519c9f83c0f9092507185ba46cb21231f60df9fe'
  head "https://github.com/GalSim-developers/GalSim.git"

  depends_on "scons" => :build
  depends_on "fftw"
  depends_on "boost"
  depends_on "tmv-cpp"

  # pyfits should come from pip
  depends_on "pyfits" => :python
  depends_on "numpy" => :python

  option "with-openmp", "Enable openmp support (gcc only)"

  def pyver
    IO.popen("python -c 'import sys; print sys.version[:3]'").read.strip
  end

  def install
    args = []
    if build.with? "openmp"
      if ENV.compiler == :clang
        opoo "OpenMP support will not be enabled. Use --cc=gcc-4.2 (formerly --use-gcc) if you require OpenMP."
      end
      args << "WITH_OPENMP=true"
    end
    system "scons", *args
    system "scons install PREFIX=#{prefix} PYPREFIX=#{lib}/python#{pyver}"
  end

  def caveats; <<-EOS.undent
    The GalSim installer may warn you that #{lib}/python isn't in your python search path.
    You may want to add all Homebrew python packages to the default paths by running:
       sudo bash -c 'echo \"/usr/local/lib/python\" >> \\\\
         /Library/Python/#{pyver}/site-packages/homebrew.pth'
    Which will create the file   /Library/Python/#{pyver}/site-packages/homebrew.pth
    with contents:
      /usr/local/lib/python#{pyver}
    EOS
  end

end
