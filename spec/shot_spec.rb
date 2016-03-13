require 'spec_helper'

describe "Template Engine" do
  context "plain template string" do
    subject do
      Shot::Template.new("This is shot template engine").render
    end
    it { is_expected.to eq "This is shot template engine" }
  end

  context "string with conditional" do
    subject do
      template = (<<-template).gsub(/  /, "")
        @if true
          Zucy
          This is shot
        @else
          Another template engine
        @end
      template
      Shot::Template.new(template).render
    end
    it { is_expected.to eq "Zucy\nThis is shot" }
  end

  context "nil variable" do
    subject do
      Shot::Template.new("{{ name }}").
        render name: nil
    end
    it { is_expected.to eq "" }
  end

  context "comment" do
    subject do
      template = (<<-EOT).gsub(/  /, "")
      Awesome
      @ # Comment is here
      Shot Template Engine
      EOT
      Shot::Template.new(template).render
    end
    it { is_expected.to eq "Awesome\nShot Template Engine" }
  end

  context "html tags" do
    subject do
      template = (<<-EOT)
        <html>
          <head>
            <title>{{ title }}</title>
          </head>
        </html>
        EOT
      Shot::Template.new(template).
        render(title: "Zucy Framework")
    end

    let(:compiled_template) do
      (<<-EOT)
        <html>
          <head>
            <title>Zucy Framework</title>
          </head>
        </html>
        EOT
    end
    it { is_expected.to eq compiled_template.chomp }
  end

  context "html file" do
    subject do
      file = File.join(__dir__, "todo.html.shot")
      Shot::Template.new(file).render(title: "Shot Template Engine")
    end

    let(:compiled_template) do
      "<html>\n  <head>\n    <title>Shot Template Engine</title>\n  </head>\n</html>"
    end
    it { is_expected.to eq compiled_template }
  end
end
