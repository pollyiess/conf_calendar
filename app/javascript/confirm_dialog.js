import { Turbo } from "@hotwired/turbo-rails"

function buildDialog(message, label) {
  const dialog = document.createElement("dialog")
  dialog.className =
    "m-auto w-[min(92vw,26rem)] rounded-2xl border border-slate-200 bg-white p-0 shadow-xl backdrop:bg-slate-900/40"

  dialog.innerHTML = `
    <div class="p-6">
      <div class="flex items-start gap-4">
        <div class="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-red-50 text-lg font-bold text-red-600">!</div>
        <div class="min-w-0">
          <h2 class="text-base font-semibold text-slate-900">Подтвердите действие</h2>
          <p data-message class="mt-1 text-sm text-slate-600"></p>
        </div>
      </div>
      <div class="mt-6 flex justify-end gap-3">
        <button type="button" data-cancel autofocus
                class="rounded-xl bg-slate-100 px-4 py-2 text-sm font-medium text-slate-700 hover:bg-slate-200">Отмена</button>
        <button type="button" data-confirm
                class="rounded-xl bg-red-600 px-4 py-2 text-sm font-semibold text-white hover:bg-red-700"></button>
      </div>
    </div>`

  dialog.querySelector("[data-message]").textContent = message
  dialog.querySelector("[data-confirm]").textContent = label || "Удалить"
  return dialog
}

function confirmDialog(message, _element, submitter) {
  return new Promise((resolve) => {
    const dialog = buildDialog(message, submitter?.dataset?.confirmLabel)
    document.body.appendChild(dialog)

    dialog.querySelector("[data-confirm]").addEventListener("click", () => dialog.close("confirm"))
    dialog.querySelector("[data-cancel]").addEventListener("click", () => dialog.close("cancel"))
    dialog.addEventListener("click", (event) => {
      if (event.target === dialog) dialog.close("cancel")
    })
    dialog.addEventListener("close", () => {
      resolve(dialog.returnValue === "confirm")
      dialog.remove()
    })

    dialog.showModal()
  })
}

if (Turbo.config?.forms) {
  Turbo.config.forms.confirm = confirmDialog
} else {
  Turbo.setConfirmMethod(confirmDialog)
}