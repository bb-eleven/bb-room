/** @type {import('tailwindcss').Config} */
module.exports = {
	content: ['./src/**/*.{html,js,svelte,ts}'],
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
			},
			fontFamily: {
				logo: 'MeshedDisplay-SemiBold',
				text: 'BLMelody-Regular',
			},
		},
	},
	plugins: [],
};
