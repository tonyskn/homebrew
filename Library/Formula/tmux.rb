require 'formula'

class Tmux < Formula
  url 'http://sourceforge.net/projects/tmux/files/tmux/tmux-1.5/tmux-1.5.tar.gz'
  md5 '3d4b683572af34e83bc8b183a8285263'
  homepage 'http://tmux.sourceforge.net'

  depends_on 'libevent'

  def patches
     DATA
  end

  def install
    ENV.append "LDFLAGS", '-lresolv'
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make install"

    # Install bash completion scripts for use with bash-completion
    (prefix+'etc/bash_completion.d').install "examples/bash_completion_tmux.sh" => 'tmux'
  end

  def caveats; <<-EOS.undent
    Bash completion script was installed to:
      #{etc}/bash_completion.d/tmux
    EOS
  end
end

__END__
diff --git a/server.c b/server.c
index 902acfa..ec1d5f8 100644
--- a/server.c
+++ b/server.c
@@ -35,6 +35,8 @@
 #include <time.h>
 #include <unistd.h>
 
+void *_vprocmgr_detach_from_console(unsigned int flags);
+
 #include "tmux.h"
 
 /*
@@ -130,8 +132,8 @@ server_start(void)
 	 * Must daemonise before loading configuration as the PID changes so
 	 * $TMUX would be wrong for sessions created in the config file.
 	 */
-	if (daemon(1, 0) != 0)
-		fatal("daemon failed");
+	if (_vprocmgr_detach_from_console(0) != NULL)
+		fatalx("_vprocmgr_detach_from_console failed");
 
 	/* event_init() was called in our parent, need to reinit. */
 	if (event_reinit(ev_base) != 0)
