class AssimpEphidrena < Formula
  desc "Ephidrena-curdled library for importing many well-known 3D model formats"
  homepage "https://www.assimp.org/"
  url "https://github.com/ephidrena/assimp/archive/refs/tags/v0.0.2-ephtest.tar.gz"
  sha256 "382da3780a611da94f952a95290eb959bd63ee2b898406e348056a692e0f0818"
  license :cannot_represent
  head "https://github.com/ephidrena/assimp.git"

  bottle do
    root_url "https://github.com/ephidrena/homebrew-acetous/releases/download/assimp-ephidrena-0.0.2"
    sha256 cellar: :any,                 catalina:     "70f60a903d4250ed2e6763d5eda75858776751fa003e9c003862b57c8291e09a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b4d611751f9995efee916b32bf64fb6bd4aa65820d09156f8e940dfbbb68c771"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    args = std_cmake_args
    args << "-DASSIMP_BUILD_TESTS=OFF"
    args << "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", *args
    system "make", "install"
  end

  test do
    # Library test.
    (testpath/"test.cpp").write <<~EOS
      #include <assimp/Importer.hpp>
      int main() {
        Assimp::Importer importer;
        return 0;
      }
    EOS
    system ENV.cc, "-std=c++11", "test.cpp", "-L#{lib}", "-lassimp", "-o", "test"
    system "./test"

    # Application test.
    (testpath/"test.obj").write <<~EOS
      # WaveFront .obj file - a single square based pyramid

      # Start a new group:
      g MySquareBasedPyramid

      # List of vertices:
      # Front left
      v -0.5 0 0.5
      # Front right
      v 0.5 0 0.5
      # Back right
      v 0.5 0 -0.5
      # Back left
      v -0.5 0 -0.5
      # Top point (top of pyramid).
      v 0 1 0

      # List of faces:
      # Square base (note: normals are placed anti-clockwise).
      f 4 3 2 1
      # Triangle on front
      f 1 2 5
      # Triangle on back
      f 3 4 5
      # Triangle on left side
      f 4 1 5
      # Triangle on right side
      f 2 3 5
    EOS
    system bin/"assimp", "export", "test.obj", "test.ply"
  end
end
