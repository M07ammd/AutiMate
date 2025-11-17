import { useState } from 'react';
import { useTranslation } from 'react-i18next';


function Header({ activeSection, scrollToSection, darkMode, toggleDarkMode }) {
  const { t, i18n } = useTranslation();
  const [isMenuOpen, setIsMenuOpen] = useState(false);

  const toggleLanguage = () => {
    const newLang = i18n.language === 'ar' ? 'en' : 'ar';
    i18n.changeLanguage(newLang);
    localStorage.setItem('language', newLang);
    document.documentElement.setAttribute('dir', newLang === 'ar' ? 'rtl' : 'ltr');
    document.documentElement.setAttribute('lang', newLang);
  };

  const handleNavClick = (sectionId) => {
    scrollToSection(sectionId);
    setIsMenuOpen(false);
  };

  return (
    <header className="header">
      <div className="header-container">
        <div className="logo">
          {/* <span className="logo-icon">🧩</span>
          <span className="logo-text">AutiMate</span> */}
          <img src="logo.png" alt="logo" className='logo_img' />
        </div>

        <button
          className="mobile-menu-toggle"
          onClick={() => setIsMenuOpen(!isMenuOpen)}
          aria-label="Toggle menu"
        >
          ☰
        </button>

        <nav className={`nav ${isMenuOpen ? 'open' : ''}`}>
          <a
            href="#home"
            className={activeSection === 'home' ? 'active' : ''}
            onClick={(e) => { e.preventDefault(); handleNavClick('home'); }}
          >
            {t('nav.home')}
          </a>
          <a
            href="#about"
            className={activeSection === 'about' ? 'active' : ''}
            onClick={(e) => { e.preventDefault(); handleNavClick('about'); }}
          >
            {t('nav.about')}
          </a>
          <a
            href="#ai-role"
            className={activeSection === 'ai-role' ? 'active' : ''}
            onClick={(e) => { e.preventDefault(); handleNavClick('ai-role'); }}
          >
            {t('nav.aiRole')}
          </a>
          <a
            href="#team"
            className={activeSection === 'team' ? 'active' : ''}
            onClick={(e) => { e.preventDefault(); handleNavClick('team'); }}
          >
            {t('nav.team')}
          </a>
          <a
            href="#contact"
            className={activeSection === 'contact' ? 'active' : ''}
            onClick={(e) => { e.preventDefault(); handleNavClick('contact'); }}
          >
            {t('nav.contact')}
          </a>

          {/* Language & Dark Mode Toggles */}
          <div className="header-controls">
            <button 
              className="control-btn lang-btn" 
              onClick={toggleLanguage}
              title={i18n.language === 'ar' ? 'Switch to English' : 'التبديل للعربية'}
            >
              {i18n.language === 'ar' ? 'EN' : 'ع'}
            </button>
            <button 
              className="control-btn dark-mode-btn" 
              onClick={toggleDarkMode}
              title={darkMode ? 'Light Mode' : 'Dark Mode'}
            >
              {darkMode ? '☀️' : '🌙'}
            </button>
          </div>
        </nav>
      </div>
    </header>
  );
}

export default Header;

