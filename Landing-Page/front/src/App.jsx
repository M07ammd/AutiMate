import { useState, useEffect } from 'react'
import { useTranslation } from 'react-i18next'
import './App.css'
import './i18n'
import Header from './components/Header'
import Hero from './components/Hero'
import About from './components/About'
import AIRole from './components/AIRole'
import Team from './components/Team'
import AppShowcase from './components/AppShowcase'
import Contact from './components/Contact'
import Footer from './components/Footer'
import ChatBot from './components/ChatBot'

function App() {
  const [isVisible, setIsVisible] = useState(false)
  const [activeSection, setActiveSection] = useState('home')
  const [darkMode, setDarkMode] = useState(false)
  const { i18n } = useTranslation()

  useEffect(() => {
    setIsVisible(true)

    // Load saved preferences
    const savedDarkMode = localStorage.getItem('darkMode') === 'true'
    setDarkMode(savedDarkMode)

    if (savedDarkMode) {
      document.body.classList.add('dark-mode')
    }

    // Set initial direction based on language
    document.documentElement.setAttribute('dir', i18n.language === 'ar' ? 'rtl' : 'ltr')
    document.documentElement.setAttribute('lang', i18n.language)

    const handleScroll = () => {
      const cards = document.querySelectorAll('.ai-card, .about-feature-item')
      cards.forEach(card => {
        const rect = card.getBoundingClientRect()
        if (rect.top < window.innerHeight - 100) {
          card.classList.add('visible')
        }
      })

      // Update active section based on scroll
      const sections = ['home', 'about', 'ai-role', 'team', 'contact']
      for (let section of sections) {
        const element = document.getElementById(section)
        if (element) {
          const rect = element.getBoundingClientRect()
          if (rect.top <= 100 && rect.bottom >= 100) {
            setActiveSection(section)
            break
          }
        }
      }
    }

    window.addEventListener('scroll', handleScroll)
    handleScroll()

    return () => window.removeEventListener('scroll', handleScroll)
  }, [i18n.language])

  const toggleDarkMode = () => {
    const newDarkMode = !darkMode
    setDarkMode(newDarkMode)
    localStorage.setItem('darkMode', newDarkMode)
    document.body.classList.toggle('dark-mode')
  }

  const scrollToSection = (sectionId) => {
    const element = document.getElementById(sectionId)
    if (element) {
      element.scrollIntoView({ behavior: 'smooth' })
    }
  }

  return (
    <div className="landing-page">
      <Header
        activeSection={activeSection}
        scrollToSection={scrollToSection}
        darkMode={darkMode}
        toggleDarkMode={toggleDarkMode}
      />

      <Hero isVisible={isVisible} />

      <About />

      <AIRole />

      <AppShowcase />

      <Team />

      <Contact />

      <Footer scrollToSection={scrollToSection} />

      <ChatBot />
    </div>
  )
}

export default App
