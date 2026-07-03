/**
 * Michigan Trip vacation info page.
 * Static content only — no API calls, no dynamic data.
 */

const lastModifiedEl = document.getElementById('last-modified');
if (lastModifiedEl) {
  const formatted = new Date().toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  });
  lastModifiedEl.textContent = `Last updated: ${formatted}`;
}
