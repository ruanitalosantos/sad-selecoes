import re
import sys

file_path = 'formulario.html'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Remove os blocos de HTML dos modais
content = re.sub(r'<div class="modal fade" id="preRegistrationModal".*?</div>\s*</div>\s*</div>', '', content, flags=re.DOTALL)
content = re.sub(r'<!-- Modal: Inscrições encerradas -->\s*<div class="modal fade" id="closedRegistrationModal".*?</div>\s*</div>\s*</div>', '', content, flags=re.DOTALL)
content = re.sub(r'<!-- Modal: Já possui inscrição -->\s*<div class="modal fade" id="existingInscricaoModal".*?</div>\s*</div>\s*</div>', '', content, flags=re.DOTALL)
content = re.sub(r'<div class="modal fade" id="friendlyAlert".*?</div>\s*</div>\s*</div>', '', content, flags=re.DOTALL)

# 2. Refatorar friendlyAlert
new_friendly_alert = '''    function showFriendlyAlert(title, message, titleClass = 'text-dark', firstInvalidField = null) {
      let msgHtml = '';
      if (typeof message === 'string') {
          msgHtml = message;
      } else if (Array.isArray(message)) {
          msgHtml = message.join('<br>');
      } else if (message instanceof Node) {
          const wrapper = document.createElement('div');
          wrapper.appendChild(message.cloneNode(true));
          msgHtml = wrapper.innerHTML;
      } else {
          msgHtml = String(message ?? '');
      }

      Swal.fire({
          title: title || 'Aviso!',
          html: msgHtml,
          icon: titleClass.includes('danger') ? 'error' : (titleClass.includes('success') ? 'success' : 'warning'),
          confirmButtonColor: '#0046ad',
          confirmButtonText: 'Entendi'
      }).then(() => {
          if (firstInvalidField) {
              requestAnimationFrame(() => {
                  firstInvalidField.scrollIntoView({ behavior: 'smooth', block: 'center' });
                  firstInvalidField.focus({ preventScroll: true });
              });
          }
      });
    }'''
content = re.sub(r'function showFriendlyAlert\(.*?\).*?_firstInvalidField = null;\s*\}\s*\}', new_friendly_alert, content, flags=re.DOTALL)

# 3. Refatorar checkRegistrationClosed
new_check_reg = '''    const checkRegistrationClosed = () => {
      console.log('%c[SAD-Seleções] checkRegistrationClosed()', 'color:#c00;font-weight:bold');
      if (!REGISTRATION_EXPIRED) {
        return;
      }
      const [y, m, d] = _terminoStr.split('-');
      const dateStr = `${d}/${m}/${y}`;
      
      Swal.fire({
        title: 'Inscrições Encerradas',
        html: `As inscrições foram encerradas no dia <b>${dateStr}</b>.<br><br>Você ainda pode consultar suas inscrições na aba <b>Resumo</b>.`,
        icon: 'error',
        confirmButtonColor: '#0046ad',
        confirmButtonText: 'OK',
        allowOutsideClick: false,
        allowEscapeKey: false
      }).then(() => {
         hideInscricaoNavLink();
         showTab('resumo');
      });
    };'''
content = re.sub(r'const checkRegistrationClosed = \(\) => \{.*?\} else \{\s*console\.warn.*?\}\s*\};', new_check_reg, content, flags=re.DOTALL)

# 4. Refatorar checkExistingInscricoes
new_check_ext = '''    const checkExistingInscricoes = async () => {
      if (REGISTRATION_EXPIRED) return;
      if (!isNaN(REGISTRATION_START.getTime()) && new Date() < REGISTRATION_START) return;

      const cpf = document.getElementById('cpf')?.value?.trim();
      if (!cpf) return;

      try {
        const response = await fetch(
          'https://webhook-n8n-dev-conectarecife.recife.pe.gov.br/webhook/consultar-dados-raps',
          { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ cpf }) }
        );
        const rawText = await response.text();
        let data = null;
        try { data = JSON.parse(rawText); } catch (_) {}
        const items = Array.isArray(data) ? data : (data && typeof data === 'object' ? [data] : []);
        if (!items.length) return;

        Swal.fire({
            title: 'Inscrição já realizada',
            html: `Você já possui <b>${items.length} inscrição(ões)</b> cadastrada(s) neste processo seletivo.<br><br>Deseja realizar uma nova inscrição ou consultar as existentes?`,
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#0046ad',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Ver minhas inscrições',
            cancelButtonText: 'Realizar nova inscrição',
            allowOutsideClick: false,
            allowEscapeKey: false,
            reverseButtons: true
        }).then((result) => {
            if (result.isConfirmed) {
                showTab('resumo');
            }
        });
      } catch (err) {
        console.error('Erro ao verificar inscrições existentes:', err);
      }
    };'''
content = re.sub(r'const checkExistingInscricoes = async \(\) => \{.*?if \(modal && typeof bootstrap !== \'undefined\'\) \{.*?\}\s*\} catch \(err\) \{.*?\}\s*\};', new_check_ext, content, flags=re.DOTALL)

# 5. Remover handlers dos botões dos modais
content = re.sub(r'// Close button handler with redirect.*?\}\s*\}\s*const hideInscricaoNavLink', 'const hideInscricaoNavLink', content, flags=re.DOTALL)
content = re.sub(r'// Modal: inscrições encerradas.*?showTab\(\'resumo\'\);\s*\}\);\s*\}', '', content, flags=re.DOTALL)
content = re.sub(r'// Modal: já tem inscrição — nova inscrição.*?if \(m\) m\.hide\(\);\s*\}\);\s*\}', '', content, flags=re.DOTALL)
content = re.sub(r'// Modal: já tem inscrição — ver inscrições.*?showTab\(\'resumo\'\);\s*\}\);\s*\}', '', content, flags=re.DOTALL)


# 6. Refatorar initFormState (Pre-reg countdown)
new_pre_reg = '''      if (REGISTRATION_START && new Date() < REGISTRATION_START) {
        if (mainContent) mainContent.classList.add('form-blocked');
        if (wizardShell) wizardShell.classList.add('form-blocked');
        
        Swal.fire({
            title: 'Inscrições ainda não abertas',
            html: `As inscrições para este processo seletivo ainda não estão abertas.<br><br><b>Abertura em:</b><br><div id="preRegCountdown" style="font-size: 1.25rem; font-weight: bold; margin-top: 10px;">Carregando...</div>`,
            icon: 'info',
            confirmButtonColor: '#0046ad',
            confirmButtonText: 'Fechar',
            allowOutsideClick: false,
            allowEscapeKey: false
        }).then(() => {
            if (preRegCountdownInterval) clearInterval(preRegCountdownInterval);
            window.location.href = 'https://sad.recife.pe.gov.br/selecoes';
        });
        
        updatePreRegCountdown();
        preRegCountdownInterval = setInterval(updatePreRegCountdown, 1000);
      }'''
content = re.sub(r'if \(REGISTRATION_START && new Date\(\) < REGISTRATION_START\) \{.*?\/\/\s*Show modal.*?if \(preRegModal && typeof bootstrap !== \'undefined\' && bootstrap\?\.Modal\).*?preRegCountdownInterval = setInterval\(updatePreRegCountdown, 1000\);\s*\}\s*\}', new_pre_reg, content, flags=re.DOTALL)

# Final Fallback check at line ~5080
content = re.sub(r'\/\/\s*Force Modal Display.*?console\.error\(\'Modal element #preRegistrationModal NOT FOUND\'\);\s*\}', '', content, flags=re.DOTALL)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Done!")
