class QtVirtManager < Formula
  desc "Qt5 Application for managing virtual machines"
  homepage "http://f1ash.github.io/qt-virt-manager/"
  url "https://github.com/F1ash/qt-virt-manager.git",
  :revision => "a5cd33344ae6ea7ac4989ca03a5cc5f020626d55",
  :using => :git
  version "0.70.91.1" # random version
  #sha256 "???"

  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "cmake" => :build

  depends_on "hicolor-icon-theme"
  depends_on "spice-client-glib2"
  depends_on "qtermwidget"
  depends_on "libvnc"
  depends_on "libvirt-glib"
  depends_on "shared-mime-info"
  depends_on :x11

  # Add an option to specify the destionation of the .app
  patch :DATA
  
  def install
    args = std_cmake_args
    args<<"-DBUILD_QT_VERSION=5"
    args<<"-DWITH_LIBCACARD=0"
    args<<"-DBUILD_TYPE=Release"
    args<<"-DUSE_SPICE_AUDIO=1"
    args<<"-DQT5_LIB_PATH=#{Formula["qt5"].prefix}"
    args<<"-DVNC_LIB_PATH=#{Formula["libvnc"].prefix}"
    args<<"-DSPICE_LIB_PATH=#{Formula["spice-protocol"].prefix}"
    args<<"-DAPPLE_APP_INSTALL_PREFIX=#{prefix}"
      mkdir "build" do
          system "cmake", "..", *args
          system "make", "install"
      end
  end

  def post_install
    # manual schema compile step
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    # manual icon cache update step
    #system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  def caveats
    <<~EOS
      The app is installed but is not linked in /Applications. If you need to have the app there, please link it with the following command:
      
        ln -s #{prefix}/*.app /Applications/
      
    EOS
  end
  
  test do
    system "#{bin}/echo",
      "#{Formula["qt-virt-manager"].opt_bin}/qt-virt-manager",
      "built & installed."
  end
end
__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index a18c17d2..e0d57a47 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -7,6 +7,9 @@ endif ()
 if (NOT SHARE_INSTALL_PREFIX)
     set (SHARE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}/share")
 endif ()
+if (NOT APPLE_APP_INSTALL_PREFIX)
+    set (APPLE_APP_INSTALL_PREFIX /Applications)
+endif ()
 
 list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")
     
@@ -1210,7 +1213,7 @@ if    (NOT APPLE)
         DESTINATION ${SHARE_INSTALL_PREFIX}/icons/hicolor/256x256/apps )
 else  (NOT APPLE)
     install ( FILES src/icons/256x256/apps/virtual-engineering.png
-        DESTINATION /Applications/${PROJECT_NAME}.app/Contents/Resources )
+        DESTINATION ${APPLE_APP_INSTALL_PREFIX}/${PROJECT_NAME}.app/Contents/Resources )
     MESSAGE(STATUS "Copy app icon for QtVirtManaget")
 endif (NOT APPLE)
 
@@ -1249,7 +1252,7 @@ if ( WITH_VNC_SUPPORT OR WITH_SPICE_SUPPORT )
             DESTINATION ${SHARE_INSTALL_PREFIX}/icons/hicolor/256x256/apps )
     else  (NOT APPLE)
         install ( FILES src/icons/256x256/apps/remote-desktop-viewer.png
-            DESTINATION /Applications/${PROJECT_NAME}.app/Contents/Resources )
+            DESTINATION ${APPLE_APP_INSTALL_PREFIX}/${PROJECT_NAME}.app/Contents/Resources )
         MESSAGE(STATUS "Copy app icon for Remote Viewer")
     endif (NOT APPLE)
 install ( FILES ${VIEWER_MIME_FILE}
