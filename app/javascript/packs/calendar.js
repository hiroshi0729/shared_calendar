import { Calendar } from '@fullcalendar/core';
import dayGridPlugin from '@fullcalendar/daygrid';
import timeGridPlugin from '@fullcalendar/timegrid';
import interactionPlugin from '@fullcalendar/interaction';

document.addEventListener('turbo:load', function() {
  const calendarEl = document.getElementById('calendar');
  
  if (calendarEl) {
    const calendar = new Calendar(calendarEl, {
      plugins: [dayGridPlugin, timeGridPlugin, interactionPlugin],
      initialView: 'timeGridWeek', // 週表示（時間軸付き）
      headerToolbar: {
        left: 'prev,next today',
        center: 'title',
        right: 'dayGridMonth,timeGridWeek,timeGridDay'
      },
      locale: 'ja', // 日本語表示
      buttonText: {
        today: '今日',
        month: '月',
        week: '週',
        day: '日'
      },
      slotMinTime: '00:00:00', // 表示開始時間
      slotMaxTime: '24:00:00', // 表示終了時間
      allDaySlot: true, // 終日イベントスロット
      navLinks: true, // 日付クリックで日表示に移動
      selectable: true, // 時間範囲選択を有効化
      selectMirror: true,
      editable: true, // ドラッグ&ドロップを有効化
      dayMaxEvents: true,
      
      // イベントデータを取得
      events: '/events.json',
      
      // 時間をクリックして予定を作成
      select: function(info) {
        const title = prompt('予定のタイトルを入力してください:');
        
        if (title) {
          // サーバーに予定を保存
          fetch('/events', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
              'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
            },
            body: JSON.stringify({
              event: {
                title: title,
                start_time: info.startStr,
                end_time: info.endStr
              }
            })
          })
          .then(response => response.json())
          .then(data => {
            // カレンダーに予定を追加
            calendar.addEvent({
              id: data.id,
              title: data.title,
              start: data.start_time,
              end: data.end_time
            });
            calendar.unselect();
          })
          .catch(error => {
            console.error('Error:', error);
            alert('予定の作成に失敗しました');
          });
        } else {
          calendar.unselect();
        }
      },
      
      // イベントをクリックして詳細表示・編集
      eventClick: function(info) {
        if (confirm(`「${info.event.title}」を削除しますか?`)) {
          // サーバーから予定を削除
          fetch(`/events/${info.event.id}`, {
            method: 'DELETE',
            headers: {
              'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
            }
          })
          .then(() => {
            info.event.remove();
          })
          .catch(error => {
            console.error('Error:', error);
            alert('予定の削除に失敗しました');
          });
        }
      }
    });
    
    calendar.render();
  }
});