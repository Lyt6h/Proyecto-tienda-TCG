document.addEventListener("turbo:load", function() {
  const passwordInput = document.getElementById("password-input");
  const toggleBtn = document.getElementById("toggle-password-btn");

  if (!passwordInput || !toggleBtn) return;

  toggleBtn.addEventListener("click", function() {
    if (passwordInput.type === "password") {
      passwordInput.type = "text";
    } else {
      passwordInput.type = "password";
    }

    toggleBtn.classList.toggle("active");
  });
});