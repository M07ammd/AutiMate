import { useTranslation } from 'react-i18next';

function AppShowcase() {
  const { t } = useTranslation();

  return (
    <section id="app-showcase" className="app-showcase-section">
      <div className="app-showcase-container">
        <div className="showcase-content">
          <div className="showcase-text">
            <span className="showcase-badge">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                <path d="M12 2L2 7l10 5 10-5-10-5z"/>
                <path d="M2 17l10 5 10-5M2 12l10 5 10-5"/>
              </svg>
              {t('appShowcase.badge') || 'Coming Soon'}
            </span>
            
            <h2 className="showcase-title">
              {t('appShowcase.title') || 'Download AutiMate App'}
            </h2>
            
            <p className="showcase-description">
              {t('appShowcase.description') || 'Experience the power of AI-driven autism support right at your fingertips. Download our app and start your journey today.'}
            </p>

            <div className="showcase-features">
              <div className="feature-item">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <polyline points="20 6 9 17 4 12"/>
                </svg>
                <span>{t('appShowcase.feature1') || 'Interactive Learning Modules'}</span>
              </div>
              <div className="feature-item">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <polyline points="20 6 9 17 4 12"/>
                </svg>
                <span>{t('appShowcase.feature2') || 'Real-time Progress Tracking'}</span>
              </div>
              <div className="feature-item">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <polyline points="20 6 9 17 4 12"/>
                </svg>
                <span>{t('appShowcase.feature3') || 'Personalized AI Support'}</span>
              </div>
            </div>

            <div className="download-buttons">
              <a href="#" className="download-btn app-store">
                <div className="btn-icon">
                  <svg viewBox="0 0 24 24" fill="currentColor">
                    <path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.81-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M13 3.5c.73-.83 1.94-1.46 2.94-1.5.13 1.17-.34 2.35-1.04 3.19-.69.85-1.83 1.51-2.95 1.42-.15-1.15.41-2.35 1.05-3.11z"/>
                  </svg>
                </div>
                <div className="btn-text">
                  <span className="btn-subtitle">{t('appShowcase.downloadOn') || 'Download on the'}</span>
                  <span className="btn-title">App Store</span>
                </div>
              </a>

              <a href="#" className="download-btn google-play">
                <div className="btn-icon">
                  <svg viewBox="0 0 24 24" fill="currentColor">
                    <path d="M3,20.5V3.5C3,2.91 3.34,2.39 3.84,2.15L13.69,12L3.84,21.85C3.34,21.6 3,21.09 3,20.5M16.81,15.12L6.05,21.34L14.54,12.85L16.81,15.12M20.16,10.81C20.5,11.08 20.75,11.5 20.75,12C20.75,12.5 20.53,12.9 20.18,13.18L17.89,14.5L15.39,12L17.89,9.5L20.16,10.81M6.05,2.66L16.81,8.88L14.54,11.15L6.05,2.66Z"/>
                  </svg>
                </div>
                <div className="btn-text">
                  <span className="btn-subtitle">{t('appShowcase.getItOn') || 'GET IT ON'}</span>
                  <span className="btn-title">Google Play</span>
                </div>
              </a>
            </div>

            <p className="coming-soon-text">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                <circle cx="12" cy="12" r="10"/>
                <polyline points="12 6 12 12 16 14"/>
              </svg>
              {t('appShowcase.comingSoon') || 'Coming Soon - Stay Tuned!'}
            </p>
          </div>

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

        {/* Decorative Elements */}
        <div className="showcase-decoration decoration-1">
          <svg viewBox="0 0 200 200" fill="none">
            <circle cx="100" cy="100" r="80" stroke="currentColor" strokeWidth="2" opacity="0.2"/>
            <circle cx="100" cy="100" r="60" stroke="currentColor" strokeWidth="2" opacity="0.3"/>
            <circle cx="100" cy="100" r="40" stroke="currentColor" strokeWidth="2" opacity="0.4"/>
          </svg>
        </div>
        <div className="showcase-decoration decoration-2">
          <svg viewBox="0 0 200 200" fill="none">
            <path d="M100 20 L180 180 L20 180 Z" stroke="currentColor" strokeWidth="2" opacity="0.2"/>
          </svg>
        </div>
      </div>
    </section>
  );
}

export default AppShowcase;

