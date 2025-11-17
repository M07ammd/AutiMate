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
          {/* <svg viewBox="0 0 400 300" className="hero-svg">
            <rect x="50" y="50" width="300" height="200" rx="20" fill="#D4E4ED"/>
            <circle cx="120" cy="120" r="30" fill="#415E72"/>
            <circle cx="280" cy="120" r="35" fill="#5A7C8F"/>
            <path d="M 150 180 Q 200 150 250 180" stroke="#415E72" strokeWidth="4" fill="none"/>
            <rect x="180" y="100" width="40" height="60" rx="5" fill="#A8C5D6"/>
            <text x="200" y="240" textAnchor="middle" fill="#415E72" fontSize="16" fontWeight="bold">
              {t('hero.happyTogether')}
            </text>
          </svg> */}
          <div className="showcase-phones">
            <div className="phone-mockup phone-1">
              <div className="phone-frame">
                <div className="phone-notch"></div>
                <div className="phone-screen">
                  <div className="screen-content">
                    {/* App Screenshot 1 */}
                    <div className="app-screenshot">
                      <div className="screenshot-header">
                        <div className="header-icon">🧩</div>
                        <h3>AutiMate</h3>
                      </div>
                      <div className="screenshot-body">
                        <div className="welcome-card">
                          <div className="card-emoji">👋</div>
                          <h4>{t('appShowcase.screen1Title') || 'Welcome Back!'}</h4>
                          <p>{t('appShowcase.screen1Text') || 'Ready to learn today?'}</p>
                        </div>
                        <div className="activity-grid">
                          <div className="activity-item">
                            <span className="activity-emoji">📚</span>
                            <span className="activity-label">{t('appShowcase.learn') || 'Learn'}</span>
                          </div>
                          <div className="activity-item">
                            <span className="activity-emoji">🎮</span>
                            <span className="activity-label">{t('appShowcase.play') || 'Play'}</span>
                          </div>
                          <div className="activity-item">
                            <span className="activity-emoji">📊</span>
                            <span className="activity-label">{t('appShowcase.progress') || 'Progress'}</span>
                          </div>
                          <div className="activity-item">
                            <span className="activity-emoji">⭐</span>
                            <span className="activity-label">{t('appShowcase.rewards') || 'Rewards'}</span>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div className="phone-mockup phone-2">
              <div className="phone-frame">
                <div className="phone-notch"></div>
                <div className="phone-screen">
                  <div className="screen-content">
                    {/* App Screenshot 2 */}
                    <div className="app-screenshot">
                      <div className="screenshot-header">
                        <div className="header-icon">📊</div>
                        <h3>{t('appShowcase.screen2Header') || 'Your Progress'}</h3>
                      </div>
                      <div className="screenshot-body">
                        <div className="progress-stats">
                          <div className="stat-card">
                            <div className="stat-value">85%</div>
                            <div className="stat-label">{t('appShowcase.completion') || 'Completion'}</div>
                          </div>
                          <div className="stat-card">
                            <div className="stat-value">12</div>
                            <div className="stat-label">{t('appShowcase.streak') || 'Day Streak'}</div>
                          </div>
                        </div>
                        <div className="achievement-list">
                          <div className="achievement-item">
                            <span className="achievement-icon">🏆</span>
                            <div className="achievement-info">
                              <div className="achievement-name">{t('appShowcase.achievement1') || 'First Steps'}</div>
                              <div className="achievement-progress">
                                <div className="progress-bar" style={{ width: '100%' }}></div>
                              </div>
                            </div>
                          </div>
                          <div className="achievement-item">
                            <span className="achievement-icon">⭐</span>
                            <div className="achievement-info">
                              <div className="achievement-name">{t('appShowcase.achievement2') || 'Quick Learner'}</div>
                              <div className="achievement-progress">
                                <div className="progress-bar" style={{ width: '70%' }}></div>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

export default Hero;

