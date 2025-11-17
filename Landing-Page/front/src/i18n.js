import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';

const resources = {
  ar: {
    translation: {
      nav: {
        home: 'الرئيسية',
        about: 'عن المشروع',
        aiRole: 'دور الذكاء الاصطناعي',
        team: 'فريق العمل',
        contact: 'تواصل معنا'
      },
      // hero: {
      //   title: ' ذكاء اصطناعي بقلب — صُمم ليفهم التوحد ',
      //   subtitle: 'AutiMate هو رفيقك الذكي الذي يساعد الاشخاص المصابين بالتوحد على تحسين مهارات التواصل والتعلم والمهارات العاطفية من خلال تجارب شخصية وجذابة.',
      //   cta1: 'ابدأ الآن',
      //   cta2: 'تحميل التطبيق',
      //   happyTogether: 'معاً بسعادة'
      // },

      hero: {
        title: 'تمكين كل فرد مصاب بالتوحد من خلال الذكاء الاصطناعي',
        subtitle: 'AutiMate هو رفيقك المدعوم بالذكاء الاصطناعي الذي يدعم ويراقب الأفراد المصابين بالتوحد، ويساعدهم على تحسين مهارات التواصل، التعلم، الحياة اليومية، والمهارات العاطفية من خلال تجارب شخصية وتفاعلية.',
        cta1: 'ابدأ الآن',
        cta2: 'حمّل التطبيق',
        happyTogether: 'سعداء معًا'
      },

      // about: {
      //   title: 'عن المشروع',
      //   whatIs: 'ما هو AutiMate؟',
      //   whatIsText: 'AutiMate هو منصة ذكية مبتكرة مصممة خصيصاً لدعم الاشخاص المصابين بالتوحد وأسرهم. نستخدم أحدث تقنيات الذكاء الاصطناعي لتوفير تجربة تعليمية وتفاعلية مخصصة تساعد كل طفل على تطوير مهاراته التواصلية والعاطفية والاجتماعية.',
      //   vision: 'رؤيتنا',
      //   visionText: 'نؤمن بأن كل شخص يستحق الفرصة للنمو والتطور بطريقته الخاصة. هدفنا هو توفير أدوات ذكية وسهلة الاستخدام تمكن الأطفال وأولياء الأمور من تحقيق أفضل النتائج في رحلة التعلم والتطور.',
      //   feature1Title: 'تعليم تفاعلي',
      //   feature1Text: 'دروس مخصصة تناسب احتياجات كل طفل',
      //   feature2Title: 'متابعة دقيقة',
      //   feature2Text: 'تقارير مفصلة عن تقدم الطفل',
      //   feature3Title: 'دعم شامل',
      //   feature3Text: 'مساعدة للأطفال والأسر معاً'
      // },


      about: {
        title: 'عن المشروع',
        whatIs: 'ما هو AutiMate؟',
        whatIsText: 'AutiMate هو منصة ذكية مصممة لدعم ومتابعة الأفراد المصابين بالتوحد، مع تقديم المساعدة لأسرهم ومقدمي الرعاية. يستخدم أحدث تقنيات الذكاء الاصطناعي لتقديم تجربة تعليمية وتفاعلية مخصصة تساعد المستخدمين على تطوير مهارات التواصل، العاطفة، ومهارات الحياة اليومية.',
        vision: 'رؤيتنا',
        visionText: 'نؤمن أن كل فرد يستحق الفرصة للنمو والتطور بطريقته الفريدة. هدفنا هو توفير أدوات ذكية وسهلة الاستخدام تمكّن المستخدمين وأسرهم من تحقيق تقدم ملموس في التعلم، التفاعل الاجتماعي، والتطور الشخصي.',
        feature1Title: 'التعلم التفاعلي والمهام اليومية',
        feature1Text: 'دروس وأنشطة يومية مخصصة لتتناسب مع قدرات واحتياجات كل مستخدم.',
        feature2Title: 'متابعة دقيقة للتقدم',
        feature2Text: 'تحليلات ورؤى مفصلة للأهل ومقدمي الرعاية لمتابعة التطور على مدار الوقت.',
        feature3Title: 'دعم شامل',
        feature3Text: 'دعم متكامل لكل من المستخدمين وأسرهم، يشمل التواصل مع المجتمع والوصول للأخصائيين.'
      },

      // aiRole: {
      //   title: 'دور الذكاء الاصطناعي',
      //   subtitle: 'كيف يساعد الذكاء الاصطناعي في تطوير مهارات الأطفال',
      //   card1Title: 'تحليل السلوك الذكي',
      //   card1Text: 'يقوم الذكاء الاصطناعي بمراقبة وفهم الأنماط العاطفية للطفل، ويوفر دعماً فورياً ورؤى تساعد الأطفال على التعامل مع مشاعرهم وتطوير ذكائهم العاطفي في بيئة آمنة.',
      //   card2Title: 'التعلم التفاعلي والنطق',
      //   card2Text: 'دروس تفاعلية ممتعة مع صور وأصوات وألعاب مصممة لتحسين النطق والمفردات والمهارات الاجتماعية. التعلم يصبح مغامرة مخصصة لسرعة كل طفل.',
      //   card3Title: 'لوحة تحكم الوالدين',
      //   card3Text: 'تتبع تقدم طفلك من خلال تحليلات ورؤى مفصلة. احصل على توصيات مدعومة بالذكاء الاصطناعي، واحتفل بالإنجازات، وابقَ على اتصال مع تقارير مخصصة.',
      //   card4Title: 'التخصيص الذكي',
      //   card4Text: 'يتكيف النظام مع احتياجات كل طفل بشكل فردي، ويقدم محتوى وأنشطة مخصصة بناءً على مستوى التقدم والاهتمامات الشخصية لكل طفل.'
      // },

      aiRole: {
        title: 'دور الذكاء الاصطناعي',
        subtitle: 'كيف يساهم الذكاء الاصطناعي في دعم وتنمية المصابين بالتوحد',
        card1Title: 'تحليل السلوك والمشاعر',
        card1Text: 'يقوم الذكاء الاصطناعي بمتابعة تصرفات الطفل أثناء استخدام التطبيق وتحليل تعابير وجهه ونبرة صوته، ليكتشف حالته المزاجية ويقدم استجابة مناسبة تساعده على التعبير عن مشاعره والتعامل معها بشكل إيجابي.',

        card2Title: 'مساعد ذكي للتفاعل',
        card2Text: 'شات بوت ذكي يتحدث مع المريض بلغة بسيطة، يساعده في التمارين اليومية، ويعلّمه كلمات ومهارات جديدة بأسلوب تفاعلي يتناسب مع مستواه.',

        card3Title: 'اقتراح المهام والأنشطة اليومية',
        card3Text: 'يقترح الذكاء الاصطناعي أنشطة يومية تناسب حالة الطفل ومزاجه، مما يساعده على تنمية مهاراته الاجتماعية والعاطفية بطريقة ممتعة ومنظمة.',

        card4Title: 'تحليلات ذكية للوالدين',
        card4Text: 'يقوم الذكاء الاصطناعي بتحليل تقدم الطفل في التعلم والتفاعل، ويعرض تقارير سهلة وواضحة للوالدين مع توصيات يومية لتحسين التواصل وتطوير المهارات.'
      },



      contact: {
        title: 'تواصل معنا',
        subtitle: 'نحن هنا لمساعدتك في أي وقت',
        email: 'البريد الإلكتروني',
        phone: 'الهاتف',
        address: 'العنوان',
        addressText: 'المنصوره، مصر',
        sendEmail: 'إرسال بريد',
        callNow: 'اتصل الآن',
        viewMap: 'عرض على الخريطة',
        formTitle: 'أرسل لنا رسالة',
        formSubtitle: 'سنرد عليك خلال 24 ساعة',
        name: 'الاسم',
        namePlaceholder: 'الاسم',
        emailPlaceholder: 'البريد الإلكتروني',
        phonePlaceholder: 'رقم الهاتف',
        message: 'الرسالة',
        messagePlaceholder: 'رسالتك',
        submit: 'إرسال الرسالة'
      },
      team: {
        title: 'تعرف على فريقنا',
        subtitle: 'محترفون شغوفون ملتزمون بإحداث فرق',
        viewDetails: 'عرض التفاصيل',
        back: 'رجوع',
        member1: {
          name: 'محمد حسين',
          role: 'مهندس ذكاء اصطناعي ',
        },
        member2: {
          name: ' احمد اشرف',
          role: 'مطور Backend',
        },
        member3: {
          name: 'شيماء علاء  ',
          role: 'مصممة UI/UX',
        },
        member4: {
          name: 'ريم',
          role: 'مهندسه ذكاء اصطناعي',
        },
        member5: {
          name: '  ضحي عبد الرازق',
          role: ' مطور Mobile ',
        }
      },
      appShowcase: {
        badge: 'قريباً',
        title: 'حمّل تطبيق AutiMate',
        description: 'اختبر قوة دعم التوحد المدعوم بالذكاء الاصطناعي في متناول يدك. حمّل تطبيقنا وابدأ رحلتك اليوم.',
        feature1: 'وحدات تعليمية تفاعلية',
        feature2: 'تتبع التقدم في الوقت الفعلي',
        feature3: 'دعم ذكاء اصطناعي مخصص',
        downloadOn: 'حمّل من',
        getItOn: 'متوفر على',
        comingSoon: 'قريباً - ترقبوا!',
        screen1Title: 'مرحباً بعودتك!',
        screen1Text: 'مستعد للتعلم اليوم؟',
        screen2Header: 'تقدمك',
        learn: 'تعلم',
        play: 'العب',
        progress: 'التقدم',
        rewards: 'المكافآت',
        completion: 'الإنجاز',
        streak: 'أيام متتالية',
        achievement1: 'الخطوات الأولى',
        achievement2: 'متعلم سريع'
      },
      footer: {
        tagline: 'تمكين كل طفل في رحلته الفريدة',
        quickLinks: 'روابط سريعة',
        contactUs: 'تواصل معنا',
        rights: 'جميع الحقوق محفوظة.',
        madeWith: 'صُنع بـ',
        forChildren: 'من أجل الأشخاص المصابين بالتوحد'
      },
      chatbot: {
        welcomeBubble: 'مرحباً! كيف يمكنني مساعدتك اليوم؟',
        welcomeMessage: 'مرحباً بك في AutiMate! 👋\n\nأنا هنا لمساعدتك. كيف يمكنني خدمتك اليوم؟',
        botName: 'مساعد AutiMate',
        online: 'متصل الآن',
        inputPlaceholder: 'اكتب رسالتك...',
        quickReply1: 'ما هو AutiMate؟',
        quickReply2: 'كيف يمكنني التسجيل؟',
        autoResponse: 'شكراً لرسالتك! سيتواصل معك أحد أعضاء فريقنا قريباً. 😊'
      }
    }
  },
  en: {
    translation: {
      nav: {
        home: 'Home',
        about: 'About',
        aiRole: 'AI Role',
        team: 'Our Team',
        contact: 'Contact'
      },
      // hero: {
      //   title: 'Empowering Autism Support Through AI',
      //   subtitle: 'AutiMate is your AI-powered companion that helps children with autism improve their communication, learning, and emotional skills through personalized, engaging experiences.',
      //   cta1: 'Get Started',
      //   cta2: 'Download App',
      //   happyTogether: 'Happy Together'
      // },

      hero: {
        title: 'Empowering Every Individual with Autism Through AI',
        subtitle: 'AutiMate is your AI-powered companion that supports and monitors individuals with autism, helping them improve communication, learning, daily life, and emotional skills through personalized, interactive experiences.',
        cta1: 'Get Started',
        cta2: 'Download App',
        happyTogether: 'Happy Together'
      },

      // about: {
      //   title: 'About the Project',
      //   whatIs: 'What is AutiMate?',
      //   whatIsText: 'AutiMate is an innovative smart platform designed specifically to support children with autism and their families. We use the latest AI technologies to provide a personalized educational and interactive experience that helps each child develop their communication, emotional, and social skills.',
      //   vision: 'Our Vision',
      //   visionText: 'We believe that every child deserves the opportunity to grow and develop in their own way. Our goal is to provide smart and easy-to-use tools that enable children and parents to achieve the best results in their learning and development journey.',
      //   feature1Title: 'Interactive Learning',
      //   feature1Text: 'Customized lessons to suit each child\'s needs',
      //   feature2Title: 'Accurate Tracking',
      //   feature2Text: 'Detailed reports on child progress',
      //   feature3Title: 'Comprehensive Support',
      //   feature3Text: 'Help for children and families together'
      // },

      about: {
        title: 'About the Project',
        whatIs: 'What is AutiMate?',
        whatIsText: 'AutiMate is an intelligent platform designed to support and monitor individuals with autism while assisting their families and caregivers. It uses advanced AI technologies to provide personalized learning, task management, and interactive experiences that help users improve communication, emotional, and daily life skills.',
        vision: 'Our Vision',
        visionText: 'We believe that every individual deserves the opportunity to grow and develop in their own unique way. Our goal is to provide smart, easy-to-use tools that empower both users and their families to achieve meaningful progress in learning, social interaction, and personal development.',
        feature1Title: 'Interactive Learning & Tasks',
        feature1Text: 'Customized lessons and daily tasks tailored to each user\'s abilities and needs.',
        feature2Title: 'Accurate Progress Tracking',
        feature2Text: 'Detailed insights and analytics for parents and caregivers to monitor development over time.',
        feature3Title: 'Comprehensive Support',
        feature3Text: 'Integrated support for both individuals and their families, including community engagement and access to specialists.'
      },


      // aiRole: {
      //   title: 'The Role of Artificial Intelligence',
      //   subtitle: 'How AI helps develop children\'s skills',
      //   card1Title: 'Smart Behavior Analysis',
      //   card1Text: 'AI monitors and understands the child\'s emotional patterns, providing instant support and insights that help children deal with their feelings and develop emotional intelligence in a safe environment.',
      //   card2Title: 'Interactive Learning & Speech',
      //   card2Text: 'Fun interactive lessons with images, sounds, and games designed to improve speech, vocabulary, and social skills. Learning becomes an adventure tailored to each child\'s pace.',
      //   card3Title: 'Parent Dashboard',
      //   card3Text: 'Track your child\'s progress through detailed analytics and insights. Get AI-powered recommendations, celebrate achievements, and stay connected with personalized reports.',
      //   card4Title: 'Smart Personalization',
      //   card4Text: 'The system adapts to each child\'s individual needs, providing customized content and activities based on progress level and personal interests.'
      // },

      aiRole: {
        title: 'AI Role',
        subtitle: 'How Artificial Intelligence Supports and Develops Individuals with Autism',
        card1Title: 'Behavior and Emotion Analysis',
        card1Text: 'AI monitors the child’s behavior while using the app, analyzing facial expressions and voice tone to detect their emotional state and respond with supportive interactions that help them express and manage their feelings positively.',

        card2Title: 'Smart Interactive Assistant',
        card2Text: 'An intelligent chatbot communicates with the patient using simple and friendly language, helping them with daily exercises, teaching new words and social skills through an adaptive interactive experience.',

        card3Title: 'Daily Task Recommendations',
        card3Text: 'AI suggests personalized daily activities and exercises that match the child’s mood and progress, making learning fun, consistent, and skill-focused.',

        card4Title: 'Smart Parent Dashboard',
        card4Text: 'AI analyzes the child’s progress and behavior, generating clear reports for parents along with daily recommendations to improve communication and enhance learning outcomes.'
      },

      contact: {
        title: 'Contact Us',
        subtitle: 'We are here to help you anytime',
        email: 'Email',
        phone: 'Phone',
        address: 'Address',
        addressText: 'Mansoura, Egypt',
        sendEmail: 'Send Email',
        callNow: 'Call Now',
        viewMap: 'View on Map',
        formTitle: 'Send us a Message',
        formSubtitle: 'We\'ll get back to you within 24 hours',
        name: 'Name',
        namePlaceholder: 'Name',
        emailPlaceholder: 'Email',
        phonePlaceholder: 'Phone Number',
        message: 'Message',
        messagePlaceholder: 'Your Message',
        submit: 'Send Message'
      },
      team: {
        title: 'Meet Our Team',
        subtitle: 'Passionate professionals dedicated to making a difference',
        viewDetails: 'View Details',
        back: 'Back',
        member1: {
          name: 'Mohamed Hussein',
          role: 'Machine learning Engineer',
        },
        member2: {
          name: 'Ahmed Ashraf',
          role: 'Backend Developer',
        },
        member3: {
          name: 'Shimaa Alaa',
          role: 'UI/UX Designer',
        },
        member4: {
          name: 'Reem Hesham',
          role: 'Machine learning Engineer',
        },
        member5: {
          name: 'Doha Abdelrazek',
          role: 'Mobile Developer',
        }
      },
      appShowcase: {
        badge: 'Coming Soon',
        title: 'Download AutiMate App',
        description: 'Experience the power of AI-driven autism support right at your fingertips. Download our app and start your journey today.',
        feature1: 'Interactive Learning Modules',
        feature2: 'Real-time Progress Tracking',
        feature3: 'Personalized AI Support',
        downloadOn: 'Download on the',
        getItOn: 'GET IT ON',
        comingSoon: 'Coming Soon - Stay Tuned!',
        screen1Title: 'Welcome Back!',
        screen1Text: 'Ready to learn today?',
        screen2Header: 'Your Progress',
        learn: 'Learn',
        play: 'Play',
        progress: 'Progress',
        rewards: 'Rewards',
        completion: 'Completion',
        streak: 'Day Streak',
        achievement1: 'First Steps',
        achievement2: 'Quick Learner'
      },
      footer: {
        tagline: 'Empowering every Individual\'s unique journey',
        quickLinks: 'Quick Links',
        contactUs: 'Contact Us',
        rights: 'All rights reserved.',
        madeWith: 'Made with',
        forChildren: 'for people with autism'
      },
      chatbot: {
        welcomeBubble: 'Hello! How can I help you today?',
        welcomeMessage: 'Welcome to AutiMate! 👋\n\nI\'m here to help you. How can I assist you today?',
        botName: 'AutiMate Assistant',
        online: 'Online now',
        inputPlaceholder: 'Type your message...',
        quickReply1: 'What is AutiMate?',
        quickReply2: 'How can I register?',
        autoResponse: 'Thank you for your message! One of our team members will contact you soon. 😊'
      }
    }
  }
};

i18n
  .use(initReactI18next)
  .init({
    resources,
    lng: localStorage.getItem('language') || 'en',
    fallbackLng: 'en',
    interpolation: {
      escapeValue: false
    }
  });

export default i18n;

