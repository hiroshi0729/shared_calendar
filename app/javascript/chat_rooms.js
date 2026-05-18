// app/javascript/chat_rooms.js
function scrollToBottom() {
    const container = document.getElementById('messages-container');
    if (container) {
      container.scrollTop = container.scrollHeight;
    }
  }
  
  // ページ読み込み時にスクロール
  document.addEventListener('turbo:load', scrollToBottom);
  
  // フォーム送信後にもスクロール(オプション)
  document.addEventListener('turbo:submit-end', scrollToBottom);