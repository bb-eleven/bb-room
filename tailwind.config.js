/** @type {import('tailwindcss').Config} */
module.exports = {
	content: ['./src/**/*.{html,js,svelte,ts}'],
	future: {
		hoverOnlyWhenSupported: true,
	},
	theme: {
		extend: {
			colors: {
				'pine-glade': '#C7D19E',
				'ship-cove': '#6E91B9',
				mirage: {
					DEFAULT: '#191F2D',
					dark: '#171D2B',
					darker: '#151B29',
					'darker-shadow': '#0A101E',
					light: '#1C2231',
					lighter: '#212739',
					lightest: '#2A2F45',
				},
				'cadet-blue': '#A0A8C3',
				comet: {
					DEFAULT: '#636985',
					darker: '#434965',
				},
				'orange-red-crayola': '#FF5A5F',
				cultured: '#F5F5F5',
				envy: '#88967B',
				red: '#A25C5D',
				quicksand: {
					DEFAULT: '#B99090',
					dark: '#A98080',
				},
				green: {
					DEFAULT: '#63BB85',
					100: '#B8E6C9',
					200: '#A3DBB8',
					300: '#8ED1A7',
					400: '#78C696',
					500: '#63BB85',
					600: '#4C9969',
					700: '#34774E',
					800: '#1D5532',
					900: '#053316',
				},
				yellow: {
					DEFAULT: '#FFD791',
					100: '#F2E9DA',
					200: '#F5E5C8',
					300: '#F9E0B6',
					400: '#FCDCA3',
					500: '#FFD791',
					600: '#CCAA6E',
					700: '#997D4B',
					800: '#664F28',
					900: '#332205',
				},
				brown: {
					DEFAULT: '#997862',
					100: '#E6D7CF',
					200: '#D3BFB4',
					300: '#C0A899',
					400: '#AC907D',
					500: '#997862',
					600: '#80604B',
					700: '#664834',
					800: '#4D2F1C',
					900: '#331705',
				},
				blue: {
					DEFAULT: '#6E9CA9',
					100: '#DAE3E6',
					200: '#BFD1D7',
					300: '#A4C0C8',
					400: '#89AEB8',
					500: '#6E9CA9',
					600: '#547F8C',
					700: '#3A636E',
					800: '#1F4651',
					900: '#052933',
				},
				red: {
					DEFAULT: '#D14553',
					100: '#E6B8BC',
					200: '#E19BA2',
					300: '#DC7F88',
					400: '#D6626D',
					500: '#D14553',
					600: '#AA3541',
					700: '#82252E',
					800: '#5B151C',
					900: '#330509',
				},
				off: {
					DEFAULT: '#C1B3B3',
					100: '#F4EDED',
					200: '#E7DFDF',
					300: '#DBD0D0',
					400: '#CEC2C2',
					500: '#C1B3B3',
					600: '#978787',
					700: '#6E5B5B',
					800: '#442F2F',
					900: '#1A0303',
				},
			},
			animation: {
				'rotate-180': 'rotate-180 0.5s 0s forwards',
				'rotate-360': 'rotate-360 0.5s 0s forwards',
				'slide-up': 'slide-up 0.7s 0s forwards',
			},
			keyframes: {
				'rotate-180': {
					'100%': { transform: 'rotate(180deg)' },
				},
				'rotate-360': {
					'0%': { transform: 'rotate(180deg)' },
					'100%': { transform: 'rotate(360deg)' },
				},
				// For selected item views collapse button
				'slide-up': {
					'0%': { transform: 'translateY(100%)' },
					'100%': { transform: 'translateY(0)' },
				},
			},
			fontFamily: {
				logo: 'MeshedDisplay-SemiBold',
				text: 'BLMelody-Regular',
			},
		},
	},
	plugins: [],
};
