class OnboardingSVGs {
  static const welcomeSVG = '''
<svg viewBox="0 0 400 400" xmlns="http://www.w3.org/2000/svg">
  <!-- Background -->
  <rect width="400" height="400" fill="#F5F8F5"/>
  
  <!-- Pot -->
  <path d="M150 300 L250 300 L270 380 L130 380 Z" fill="#795548"/>
  
  <!-- Plant Stem -->
  <path d="M200 300 C200 200 200 150 200 100" stroke="#2E7D32" stroke-width="8" fill="none"/>
  
  <!-- Plant Leaves -->
  <path d="M200 250 C150 200 130 220 150 250" fill="#4CAF50"/>
  <path d="M200 250 C250 200 270 220 250 250" fill="#4CAF50"/>
  <path d="M200 200 C150 150 130 170 150 200" fill="#4CAF50"/>
  <path d="M200 200 C250 150 270 170 250 200" fill="#4CAF50"/>
  <path d="M200 150 C150 100 130 120 150 150" fill="#4CAF50"/>
  <path d="M200 150 C250 100 270 120 250 150" fill="#4CAF50"/>
  
  <!-- Sun -->
  <circle cx="320" cy="80" r="40" fill="#FDD835"/>
  <g fill="none" stroke="#FDD835" stroke-width="4">
    <path d="M320 20 L320 0"/>
    <path d="M320 160 L320 140"/>
    <path d="M260 80 L240 80"/>
    <path d="M400 80 L380 80"/>
    <path d="M277 37 L263 23"/>
    <path d="M377 137 L363 123"/>
    <path d="M363 37 L377 23"/>
    <path d="M263 137 L277 123"/>
  </g>
</svg>
''';

  static const identifySVG = '''
<svg viewBox="0 0 400 400" xmlns="http://www.w3.org/2000/svg">
  <!-- Background -->
  <rect width="400" height="400" fill="#F5F8F5"/>
  
  <!-- Phone Frame -->
  <rect x="120" y="60" width="160" height="280" rx="20" fill="#424242"/>
  <rect x="130" y="70" width="140" height="260" rx="15" fill="#FFFFFF"/>
  
  <!-- Camera UI -->
  <circle cx="200" cy="200" r="60" fill="none" stroke="#2E7D32" stroke-width="4" stroke-dasharray="10"/>
  <path d="M200 130 L200 270 M130 200 L270 200" stroke="#2E7D32" stroke-width="2" stroke-dasharray="5"/>
  
  <!-- Plant Silhouette -->
  <path d="M180 220 C180 180 160 160 180 140 C200 120 220 140 220 180 L220 240 L180 240 Z" 
        fill="#81C784" fill-opacity="0.5"/>
  
  <!-- Scan Animation -->
  <rect x="130" y="195" width="140" height="10" fill="#2E7D32" fill-opacity="0.3">
    <animate attributeName="y" values="70;330;70" dur="3s" repeatCount="indefinite"/>
  </rect>
</svg>
''';

  static const careGuideSVG = '''
<svg viewBox="0 0 400 400" xmlns="http://www.w3.org/2000/svg">
  <!-- Background -->
  <rect width="400" height="400" fill="#F5F8F5"/>
  
  <!-- Notebook -->
  <rect x="100" y="80" width="200" height="260" rx="10" fill="#FFFFFF" stroke="#2E7D32" stroke-width="4"/>
  <line x1="120" y1="140" x2="280" y2="140" stroke="#2E7D32" stroke-width="2"/>
  <line x1="120" y1="180" x2="280" y2="180" stroke="#2E7D32" stroke-width="2"/>
  <line x1="120" y1="220" x2="280" y2="220" stroke="#2E7D32" stroke-width="2"/>
  <line x1="120" y1="260" x2="280" y2="260" stroke="#2E7D32" stroke-width="2"/>
  
  <!-- Care Icons -->
  <circle cx="150" cy="110" r="15" fill="#81C784"/>
  <path d="M150 100 L150 120 M140 110 L160 110" stroke="white" stroke-width="2"/>
  
  <circle cx="200" cy="110" r="15" fill="#81C784"/>
  <path d="M190 105 L210 115" stroke="white" stroke-width="2"/>
  <circle cx="200" cy="110" r="5" fill="white"/>
  
  <circle cx="250" cy="110" r="15" fill="#81C784"/>
  <path d="M245 105 C250 100 255 115 250 110" stroke="white" stroke-width="2" fill="none"/>
</svg>
''';

  static const remindersSVG = '''
<svg viewBox="0 0 400 400" xmlns="http://www.w3.org/2000/svg">
  <!-- Background -->
  <rect width="400" height="400" fill="#F5F8F5"/>
  
  <!-- Clock -->
  <circle cx="200" cy="200" r="100" fill="white" stroke="#2E7D32" stroke-width="4"/>
  <circle cx="200" cy="200" r="5" fill="#2E7D32"/>
  
  <!-- Clock Hands -->
  <line x1="200" y1="200" x2="200" y2="130" stroke="#2E7D32" stroke-width="4" stroke-linecap="round">
    <animateTransform attributeName="transform" attributeType="XML" type="rotate" from="0 200 200" to="360 200 200" dur="12s" repeatCount="indefinite"/>
  </line>
  <line x1="200" y1="200" x2="250" y2="200" stroke="#2E7D32" stroke-width="4" stroke-linecap="round">
    <animateTransform attributeName="transform" attributeType="XML" type="rotate" from="0 200 200" to="360 200 200" dur="60s" repeatCount="indefinite"/>
  </line>
  
  <!-- Water Drops -->
  <path d="M160 280 L140 320" stroke="#81C784" stroke-width="2"/>
  <path d="M140 320 C135 330 145 330 140 320" fill="#81C784"/>
  
  <path d="M200 300 L200 340" stroke="#81C784" stroke-width="2"/>
  <path d="M200 340 C195 350 205 350 200 340" fill="#81C784"/>
  
  <path d="M240 280 L260 320" stroke="#81C784" stroke-width="2"/>
  <path d="M260 320 C255 330 265 330 260 320" fill="#81C784"/>
</svg>
''';
}
