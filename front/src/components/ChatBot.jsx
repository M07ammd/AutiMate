import { useState, useEffect, useRef } from 'react';
import { useTranslation } from 'react-i18next';

function ChatBot() {
  const { t } = useTranslation();
  const [isOpen, setIsOpen] = useState(false);
  const [showWelcome, setShowWelcome] = useState(false);
  const [messages, setMessages] = useState([]);
  const [inputMessage, setInputMessage] = useState('');
  const messagesEndRef = useRef(null);

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  };

  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  useEffect(() => {
    // Show welcome message after 3 seconds
    const timer = setTimeout(() => {
      setShowWelcome(true);
    }, 3000);

    return () => clearTimeout(timer);
  }, []);

  useEffect(() => {
    if (isOpen && messages.length === 0) {
      // Add initial bot message when chat opens
      setMessages([
        {
          type: 'bot',
          text: t('chatbot.welcomeMessage') || 'مرحباً! كيف يمكنني مساعدتك اليوم؟',
          time: new Date().toLocaleTimeString('ar-EG', { hour: '2-digit', minute: '2-digit' })
        }
      ]);
    }
  }, [isOpen, messages.length, t]);

  const handleSendMessage = (e) => {
    e.preventDefault();
    if (inputMessage.trim() === '') return;

    // Add user message
    const userMessage = {
      type: 'user',
      text: inputMessage,
      time: new Date().toLocaleTimeString('ar-EG', { hour: '2-digit', minute: '2-digit' })
    };

    setMessages([...messages, userMessage]);
    setInputMessage('');

    //   // Simulate bot response after 1 second
    //   setTimeout(() => {
    //     const botMessage = {
    //       type: 'bot',
    //       text: t('chatbot.autoResponse') || 'شكراً لرسالتك! سيتواصل معك أحد أعضاء فريقنا قريباً.',
    //       time: new Date().toLocaleTimeString('ar-EG', { hour: '2-digit', minute: '2-digit' })
    //     };
    //     setMessages(prev => [...prev, botMessage]);
    //   }, 1000);


        // Send message to backend AI
    fetch("https://your-backend.vercel.app/chat", {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ message: inputMessage })
    })
      .then(res => res.json())
      .then(data => {
        const botMessage = {
          type: 'bot',
          text: data.reply || 'لم أستطع فهم سؤالك، حاول مرة أخرى 😊',
          time: new Date().toLocaleTimeString('ar-EG', { hour: '2-digit', minute: '2-digit' })
        };
        setMessages(prev => [...prev, botMessage]);
      })
      .catch(err => {
        console.error(err);
        const botMessage = {
          type: 'bot',
          text: 'حدث خطأ أثناء الاتصال بالخادم 😔',
          time: new Date().toLocaleTimeString('ar-EG', { hour: '2-digit', minute: '2-digit' })
        };
        setMessages(prev => [...prev, botMessage]);
      });
      
     };




    const toggleChat = () => {
      setIsOpen(!isOpen);
      setShowWelcome(false);
    };

    const closeWelcome = () => {
      setShowWelcome(false);
    };

    return (
      <>
        {/* Chatbot Button */}
        <div className={`chatbot-container ${isOpen ? 'open' : ''}`}>
          <button
            className="chatbot-button"
            onClick={toggleChat}
            aria-label="Open chat"
          >
            {isOpen ? (
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                <line x1="18" y1="6" x2="6" y2="18"></line>
                <line x1="6" y1="6" x2="18" y2="18"></line>
              </svg>
            ) : (
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                <path d="M21 15a2 2 0 01-2 2H7l-4 4V5a2 2 0 012-2h14a2 2 0 012 2z" />
              </svg>
            )}
          </button>

          {/* Character Avatar */}
          <div className={`chatbot-character ${isOpen ? 'hidden' : ''}`}>
            <div className="character-avatar">
              🤖
            </div>
            <div className="character-wave">👋</div>
          </div>

          {/* Welcome Bubble */}
          {showWelcome && !isOpen && (
            <div className="welcome-bubble">
              <button className="welcome-close" onClick={closeWelcome}>×</button>
              <p>{t('chatbot.welcomeBubble') || 'مرحباً! كيف يمكنني مساعدتك اليوم؟'}</p>
            </div>
          )}

          {/* Chat Window */}
          {isOpen && (
            <div className="chatbot-window">
              {/* Chat Header */}
              <div className="chat-header">
                <div className="chat-header-info">
                  <div className="chat-avatar">🤖</div>
                  <div>
                    <h4>{t('chatbot.botName') || 'مساعد AutiMate'}</h4>
                    <span className="chat-status">
                      <span className="status-dot"></span>
                      {t('chatbot.online') || 'متصل الآن'}
                    </span>
                  </div>
                </div>
                <button className="chat-close" onClick={toggleChat}>
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                    <line x1="18" y1="6" x2="6" y2="18"></line>
                    <line x1="6" y1="6" x2="18" y2="18"></line>
                  </svg>
                </button>
              </div>

              {/* Chat Messages */}
              <div className="chat-messages">
                {messages.map((message, index) => (
                  <div key={index} className={`chat-message ${message.type}`}>
                    {message.type === 'bot' && (
                      <div className="message-avatar">🤖</div>
                    )}
                    <div className="message-content">
                      <p>{message.text}</p>
                      <span className="message-time">{message.time}</span>
                    </div>
                    {message.type === 'user' && (
                      <div className="message-avatar user-avatar">👤</div>
                    )}
                  </div>
                ))}
                <div ref={messagesEndRef} />
              </div>

              {/* Quick Replies */}
              <div className="quick-replies">
                <button
                  className="quick-reply-btn"
                  onClick={() => setInputMessage(t('chatbot.quickReply1') || 'ما هو AutiMate؟')}
                >
                  {t('chatbot.quickReply1') || 'ما هو AutiMate؟'}
                </button>
                <button
                  className="quick-reply-btn"
                  onClick={() => setInputMessage(t('chatbot.quickReply2') || 'كيف يمكنني التسجيل؟')}
                >
                  {t('chatbot.quickReply2') || 'كيف يمكنني التسجيل؟'}
                </button>
              </div>

              {/* Chat Input */}
              <form className="chat-input-form" onSubmit={handleSendMessage}>
                <input
                  type="text"
                  className="chat-input"
                  placeholder={t('chatbot.inputPlaceholder') || 'اكتب رسالتك...'}
                  value={inputMessage}
                  onChange={(e) => setInputMessage(e.target.value)}
                />
                <button type="submit" className="chat-send-btn">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                    <line x1="22" y1="2" x2="11" y2="13"></line>
                    <polygon points="22 2 15 22 11 13 2 9 22 2"></polygon>
                  </svg>
                </button>
              </form>
            </div>
          )}
        </div>
      </>
    );
  }

  export default ChatBot;


// import { useState, useEffect, useRef } from 'react';
// import { useTranslation } from 'react-i18next';

// function ChatBot() {
//   const { t } = useTranslation();
//   const [isOpen, setIsOpen] = useState(false);
//   const [showWelcome, setShowWelcome] = useState(false);
//   const [messages, setMessages] = useState([]);
//   const [inputMessage, setInputMessage] = useState('');
//   const [loading, setLoading] = useState(false);
//   const messagesEndRef = useRef(null);

//   const scrollToBottom = () => {
//     messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
//   };

//   useEffect(() => {
//     scrollToBottom();
//   }, [messages]);

//   useEffect(() => {
//     const timer = setTimeout(() => setShowWelcome(true), 3000);
//     return () => clearTimeout(timer);
//   }, []);

//   useEffect(() => {
//     if (isOpen && messages.length === 0) {
//       setMessages([
//         {
//           type: 'bot',
//           text: t('chatbot.welcomeMessage') || 'مرحباً! كيف يمكنني مساعدتك اليوم؟',
//           time: new Date().toLocaleTimeString('ar-EG', { hour: '2-digit', minute: '2-digit' })
//         }
//       ]);
//     }
//   }, [isOpen, messages.length, t]);

//   const handleSendMessage = async (e) => {
//     e.preventDefault();
//     if (inputMessage.trim() === '') return;

//     const userMessage = {
//       type: 'user',
//       text: inputMessage,
//       time: new Date().toLocaleTimeString('ar-EG', { hour: '2-digit', minute: '2-digit' })
//     };
//     setMessages(prev => [...prev, userMessage]);
//     setInputMessage('');
//     setLoading(true);

//     try {
//       const res = await fetch("http://localhost:5000/chat", {
//         method: "POST",
//         headers: { "Content-Type": "application/json" },
//         body: JSON.stringify({ message: userMessage.text })
//       });
//       const data = await res.json();
//       const botMessage = {
//         type: 'bot',
//         text: data.reply || 'لم أستطع فهم سؤالك، حاول مرة أخرى 😊',
//         time: new Date().toLocaleTimeString('ar-EG', { hour: '2-digit', minute: '2-digit' })
//       };
//       setMessages(prev => [...prev, botMessage]);
//     } catch (err) {
//       console.error(err);
//       const botMessage = {
//         type: 'bot',
//         text: 'حدث خطأ أثناء الاتصال بالخادم 😔',
//         time: new Date().toLocaleTimeString('ar-EG', { hour: '2-digit', minute: '2-digit' })
//       };
//       setMessages(prev => [...prev, botMessage]);
//     } finally {
//       setLoading(false);
//     }
//   };

//   const toggleChat = () => { setIsOpen(!isOpen); setShowWelcome(false); };
//   const closeWelcome = () => setShowWelcome(false);

//   return (
//     <div className={`chatbot-container ${isOpen ? 'open' : ''}`}>
//       <button className="chatbot-button" onClick={toggleChat}>
//         {isOpen ? '×' : '💬'}
//       </button>

//       {showWelcome && !isOpen && (
//         <div className="welcome-bubble">
//           <button className="welcome-close" onClick={closeWelcome}>×</button>
//           <p>{t('chatbot.welcomeBubble') || 'مرحباً! كيف يمكنني مساعدتك اليوم؟'}</p>
//         </div>
//       )}

//       {isOpen && (
//         <div className="chatbot-window">
//           <div className="chat-messages">
//             {messages.map((m, i) => (
//               <div key={i} className={`chat-message ${m.type}`}>
//                 {m.type === 'bot' && <div className="message-avatar">🤖</div>}
//                 {m.type === 'user' && <div className="message-avatar user-avatar">👤</div>}
//                 <div className="message-content">
//                   <p>{m.text}</p>
//                   <span className="message-time">{m.time}</span>
//                 </div>
//               </div>
//             ))}
//             {loading && (
//               <div className="chat-message bot">
//                 <div className="message-avatar">🤖</div>
//                 <div className="message-content">
//                   <p>جارٍ الرد...</p>
//                 </div>
//               </div>
//             )}
//             <div ref={messagesEndRef} />
//           </div>

//           <form className="chat-input-form" onSubmit={handleSendMessage}>
//             <input
//               type="text"
//               className="chat-input"
//               placeholder={t('chatbot.inputPlaceholder') || 'اكتب رسالتك...'}
//               value={inputMessage}
//               onChange={e => setInputMessage(e.target.value)}
//             />
//             <button type="submit" className="chat-send-btn">➤</button>
//           </form>
//         </div>
//       )}
//     </div>
//   );
// }

// export default ChatBot;

