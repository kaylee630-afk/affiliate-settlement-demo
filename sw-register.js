// PWA Service Worker Registration
if ('serviceWorker' in navigator) {
  navigator.serviceWorker.register('/sw.js').catch(() => {});
}

// 监听 PWA 安装事件
let deferredPrompt;
window.addEventListener('beforeinstallprompt', (e) => {
  e.preventDefault();
  deferredPrompt = e;
  // 显示安装提示
  const banner = document.createElement('div');
  banner.style.cssText = 'position:fixed;bottom:20px;left:20px;right:20px;z-index:9999;background:#1d1d1f;color:#fff;padding:16px 20px;border-radius:16px;display:flex;align-items:center;justify-content:space-between;font-family:-apple-system,BlinkMacSystemFont,sans-serif;font-size:14px;box-shadow:0 8px 30px rgba(0,0,0,.4);animation:slideUp .3s ease;';
  banner.innerHTML = '<span>📱 <b>Install PayFlash</b> — Use like a real app</span><span style="display:flex;gap:8px"><button id="pwa-install" style="background:#6366f1;color:#fff;border:none;padding:8px 16px;border-radius:20px;font-weight:600;cursor:pointer">Install</button><button id="pwa-dismiss" style="background:none;border:none;color:#999;cursor:pointer;font-size:18px">×</button></span>';
  document.body.appendChild(banner);
  document.getElementById('pwa-install').onclick = () => { deferredPrompt.prompt(); banner.remove(); };
  document.getElementById('pwa-dismiss').onclick = () => { banner.remove(); };
  const style = document.createElement('style');
  style.textContent = '@keyframes slideUp{from{opacity:0;transform:translateY(30px)}to{opacity:1;transform:translateY(0)}}';
  document.head.appendChild(style);
});
