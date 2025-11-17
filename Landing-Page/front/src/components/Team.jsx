import { useTranslation } from 'react-i18next';

function Team() {
  const { t } = useTranslation();

  const handleImageError = (e) => {
    e.target.src = '/team/placeholder.svg';
  };

  const teamMembers = [
    {
      id: 1,
      name: t('team.member1.name') || 'Mohamed Hussein',
      role: t('team.member1.role') || 'Machine Learning Engineer',
      image: '/team/me.jpg', 
      social: {
        linkedin: '#',
        github: '#',
        email: 'mahmouda19988@gmail.com'
      }
    },
    {
      id: 2,
      name: t('team.member2.name') || 'Ahmed Ashraf',
      role: t('team.member2.role') || 'Backend Developer',
      image: '/team/ahmed.jpg',
      social: {
        linkedin: '#',
        github: '#',
        email: '@gmail.com'
      }
    },
    {
      id: 3,
      name: t('team.member3.name') || 'Shimaa alaa',
      role: t('team.member3.role') || 'UI&UX Designer',
      image: '/team/65581.png',    
      social: {
        linkedin: '#',
        github: '#',
        email: '@gmail.com'
      }
    },
    {
      id: 4,
      name: t('team.member4.name') || 'Reem Hesham ',
      role: t('team.member4.role') || 'Machine Learning Engineer',
      image: '/team/65581.png',
      social: {
        linkedin: '#',
        github: '#',
        email: '@gmail.com'
      }
    },
    {
      id: 5,
      name: t('team.member5.name') || 'Doha Abdelrazek',
      role: t('team.member5.role') || 'Mobile Developer',
      image: '/team/65581.png',      
      social: {
        linkedin: '#',
        github: '#',
        email: '@gmail.com'
      }
    }
  ];

  return (
    <section id="team" className="team-section">
      <div className="team-container">
        <div className="team-header">
          <h2 className="section-title">{t('team.title') || 'Meet Our Team'}</h2>
          <p className="section-subtitle">
            {t('team.subtitle') || 'Passionate professionals dedicated to making a difference'}
          </p>
        </div>

        <div className="team-grid">
          {teamMembers.map((member, index) => (
            <div 
              key={member.id} 
              className="team-card"
              style={{ animationDelay: `${index * 0.1}s` }}
            >
              <div className="team-card-inner">
                {/* Front of card */}
                <div className="team-card-front">
                  <div className="member-image">
                    <div className="image-wrapper">
                      <img
                        src={member.image}
                        alt={member.name}
                        className="member-photo"
                        onError={handleImageError}
                      />
                    </div>
                    <div className="member-badge">
                      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
                        <polyline points="22 4 12 14.01 9 11.01"/>
                      </svg>
                    </div>
                  </div>
                  
                  <div className="member-info">
                    <h3 className="member-name">{member.name}</h3>
                    <p className="member-role">{member.role}</p>
                    <p className="member-bio">{member.bio}</p>
                  </div>

                  <div className="card-hover-indicator">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                      <circle cx="12" cy="12" r="10"/>
                      <polyline points="12 16 16 12 12 8"/>
                      <line x1="8" y1="12" x2="16" y2="12"/>
                    </svg>
                    <span>{t('team.viewDetails') || 'View Details'}</span>
                  </div>
                </div>

                {/* Back of card */}
                <div className="team-card-back">
                  <div className="back-content">
                    <div className="member-image-small">
                      <img
                        src={member.image}
                        alt={member.name}
                        className="member-photo-small"
                        onError={handleImageError}
                      />
                    </div>
                    
                    <h3 className="member-name">{member.name}</h3>
                    <p className="member-role">{member.role}</p>
                    
                    <div className="member-details">
                      <div className="detail-item">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                          <path d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
                        </svg>
                        <span>{member.social.email}</span>
                      </div>
                    </div>

                    <div className="social-links">
                      <a href={member.social.linkedin} className="social-link" aria-label="LinkedIn">
                        <svg viewBox="0 0 24 24" fill="currentColor">
                          <path d="M19 0h-14c-2.761 0-5 2.239-5 5v14c0 2.761 2.239 5 5 5h14c2.762 0 5-2.239 5-5v-14c0-2.761-2.238-5-5-5zm-11 19h-3v-11h3v11zm-1.5-12.268c-.966 0-1.75-.79-1.75-1.764s.784-1.764 1.75-1.764 1.75.79 1.75 1.764-.783 1.764-1.75 1.764zm13.5 12.268h-3v-5.604c0-3.368-4-3.113-4 0v5.604h-3v-11h3v1.765c1.396-2.586 7-2.777 7 2.476v6.759z"/>
                        </svg>
                      </a>
                      <a href={member.social.github} className="social-link" aria-label="GitHub">
                        <svg viewBox="0 0 24 24" fill="currentColor">
                          <path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"/>
                        </svg>
                      </a>
                      <a href={`mailto:${member.social.email}`} className="social-link" aria-label="Email">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                          <path d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
                        </svg>
                      </a>
                    </div>

                    {/* <button className="back-button">
                      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                        <polyline points="15 18 9 12 15 6"/>
                      </svg>
                      {t('team.back') || 'Back'}
                    </button> */}
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}

export default Team;

