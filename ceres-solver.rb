require 'formula'

class CeresSolver < Formula
  homepage 'http://code.google.com/p/ceres-solver/'
  url 'http://ceres-solver.googlecode.com/files/ceres-solver-1.8.0.tar.gz'
  sha1 '8a67268d995b8351bd5ee5acf1eebff910028e7e'
  head 'https://ceres-solver.googlesource.com/ceres-solver.git'

  depends_on 'cmake' => :build
  depends_on 'glog'
  depends_on 'gflags'
  depends_on 'eigen'
  depends_on 'suite-sparse' => :recommended

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

end
