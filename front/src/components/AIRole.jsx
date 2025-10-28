import { useTranslation } from 'react-i18next';

function AIRole() {
  const { t } = useTranslation();

  return (
    <section id="ai-role" className="ai-role-section">
      <h2 className="section-title">{t('aiRole.title')}</h2>
      <p className="section-subtitle">{t('aiRole.subtitle')}</p>
      <div className="ai-grid">
        
        {/* AI Feature 1 */}
        <div className="ai-card">
          <div className="ai-icon">
            <svg viewBox="0 0 64 64" fill="none">
              <circle cx="32" cy="32" r="28" fill="#E8F0F5"/>
              <path d="M32 20c-6.6 0-12 5.4-12 12s5.4 12 12 12 12-5.4 12-12-5.4-12-12-12zm0 18c-3.3 0-6-2.7-6-6s2.7-6 6-6 6 2.7 6 6-2.7 6-6 6z" fill="#5A7C8F"/>
              <circle cx="32" cy="32" r="4" fill="#415E72"/>
            </svg>
          </div>
          <h3 className="ai-title">{t('aiRole.card1Title')}</h3>
          <p className="ai-description">{t('aiRole.card1Text')}</p>
        </div>

        {/* AI Feature 2 */}
        <div className="ai-card">
          <div className="ai-icon">
            <svg viewBox="0 0 64 64" fill="none">
              <circle cx="32" cy="32" r="28" fill="#D4E4ED"/>
              <rect x="20" y="24" width="24" height="20" rx="3" fill="#5A7C8F"/>
              <circle cx="26" cy="32" r="3" fill="#415E72"/>
              <circle cx="38" cy="32" r="3" fill="#415E72"/>
              <path d="M24 40c0-4 4-6 8-6s8 2 8 6" stroke="#2C4A5A" strokeWidth="2" fill="none"/>
            </svg>
          </div>
          <h3 className="ai-title">{t('aiRole.card2Title')}</h3>
          <p className="ai-description">{t('aiRole.card2Text')}</p>
        </div>

        {/* AI Feature 3 */}
        <div className="ai-card">
          <div className="ai-icon">
            <svg viewBox="0 0 64 64" fill="none">
              <circle cx="32" cy="32" r="28" fill="#EDF5F9"/>
              <rect x="18" y="22" width="28" height="20" rx="2" fill="#5A7C8F"/>
              <rect x="22" y="28" width="8" height="8" rx="1" fill="#415E72"/>
              <rect x="34" y="28" width="8" height="8" rx="1" fill="#415E72"/>
              <line x1="26" y1="26" x2="26" y2="20" stroke="#2C4A5A" strokeWidth="2"/>
              <line x1="38" y1="26" x2="38" y2="20" stroke="#2C4A5A" strokeWidth="2"/>
            </svg>
          </div>
          <h3 className="ai-title">{t('aiRole.card3Title')}</h3>
          <p className="ai-description">{t('aiRole.card3Text')}</p>
        </div>

        {/* AI Feature 4 */}
        <div className="ai-card">
          <div className="ai-icon">
            <svg viewBox="0 0 64 64" fill="none">
              <circle cx="32" cy="32" r="28" fill="#D4E4ED"/>
              <path d="M32 16 L40 28 L48 24 L44 36 L52 44 L40 40 L32 52 L24 40 L12 44 L20 36 L16 24 L24 28 Z" fill="#415E72"/>
            </svg>
          </div>
          <h3 className="ai-title">{t('aiRole.card4Title')}</h3>
          <p className="ai-description">{t('aiRole.card4Text')}</p>
        </div>

      </div>
    </section>
  );
}

export default AIRole;

