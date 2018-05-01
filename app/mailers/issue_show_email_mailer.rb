class IssueShowEmailMailer < ApplicationMailer
    def notify(email, pdf_file)
        attachments['fechamento.pdf'] = pdf_file
        mail(to: email, subject: "Fechamento da Fatura")
    end
end
