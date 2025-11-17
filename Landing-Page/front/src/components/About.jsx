import { useTranslation } from 'react-i18next';

function About() {
  const { t } = useTranslation();

  return (
    <section id="about" className="about-section">
      <h2 className="section-title">{t('about.title')}</h2>
      <div className="about-content">
        <div className="about-text">
          <h3>{t('about.whatIs')}</h3>
          <p>{t('about.whatIsText')}</p>
          <h3>{t('about.vision')}</h3>
          <p>{t('about.visionText')}</p>
        </div>
        <div className="about-features">
          <div className="about-feature-item">
            <div className="about-icon">📚</div>
            <h4>{t('about.feature1Title')}</h4>
            <p>{t('about.feature1Text')}</p>
          </div>
          <div className="about-feature-item">
            <div className="about-icon">🎯</div>
            <h4>{t('about.feature2Title')}</h4>
            <p>{t('about.feature2Text')}</p>
          </div>
          <div className="about-feature-item">
            <div className="about-icon">❤️</div>
            <h4>{t('about.feature3Title')}</h4>
            <p>{t('about.feature3Text')}</p>
          </div>
        </div>
      </div>
    </section>
  );
}

export default About;

