import "application"
import "@hotwired/turbo-rails"
import "@hotwired/stimulus"
import "@hotwired/stimulus-loading"
import "controllers"
import "bootstrap"

// Turbo のページ読み込み後に Bootstrap のドロップダウンを初期化
document.addEventListener("turbo:load", () => {
  // すべてのドロップダウン要素を取得
  const dropdownElementList = document.querySelectorAll('[data-bs-toggle="dropdown"]');
  
  // 各ドロップダウン要素を初期化
  dropdownElementList.forEach((dropdownToggleEl) => {
    new bootstrap.Dropdown(dropdownToggleEl);
  });
});

// 初回読み込み時にも実行
document.addEventListener("DOMContentLoaded", () => {
  const dropdownElementList = document.querySelectorAll('[data-bs-toggle="dropdown"]');
  
  dropdownElementList.forEach((dropdownToggleEl) => {
    new bootstrap.Dropdown(dropdownToggleEl);
  });
});
