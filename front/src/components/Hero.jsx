import { useTranslation } from 'react-i18next';

function Hero({ isVisible }) {
  const { t } = useTranslation();

  const scrollToAppShowcase = () => {
    const element = document.getElementById('app-showcase');
    if (element) {
      element.scrollIntoView({ behavior: 'smooth' });
    }
  };

  return (
    <section id="home" className={`hero ${isVisible ? 'fade-in' : ''}`}>
      <div className="hero-content">
        <h1 className="hero-title">{t('hero.title')}</h1>
        <p className="hero-subtitle">
          {t('hero.subtitle')}
        </p>
        <button className="cta-button" onClick={scrollToAppShowcase}>{t('hero.cta1')}</button>
        <button className="cta-button-secondary" onClick={scrollToAppShowcase}>{t('hero.cta2')}</button>
      </div>
      <div className="hero-image">
        <div className="image-placeholder">
          <svg viewBox="0 0 400 300" className="hero-svg">
            <rect x="50" y="50" width="300" height="200" rx="20" fill="#D4E4ED"/>
            <circle cx="120" cy="120" r="30" fill="#415E72"/>
            <circle cx="280" cy="120" r="35" fill="#5A7C8F"/>
            <path d="M 150 180 Q 200 150 250 180" stroke="#415E72" strokeWidth="4" fill="none"/>
            <rect x="180" y="100" width="40" height="60" rx="5" fill="#A8C5D6"/>
            <text x="200" y="240" textAnchor="middle" fill="#415E72" fontSize="16" fontWeight="bold">
              {t('hero.happyTogether')}
            </text>
          </svg>
        </div>
      </div>
    </section>
  );
}

export default Hero;

