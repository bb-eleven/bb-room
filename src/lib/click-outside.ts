/** Dispatch event on click outside of node */
export const clickOutside = (element: HTMLElement, callback: Function) => {

  const handleClick = (event: Event) => {
    const target = event.target as HTMLElement;
    if (element && !element.contains(target) && !event.defaultPrevented) {
      callback();
    }
  }

  document.addEventListener('click', handleClick, true);

  return {
    destroy() {
      document.removeEventListener('click', handleClick, true);
    }
  }
}
