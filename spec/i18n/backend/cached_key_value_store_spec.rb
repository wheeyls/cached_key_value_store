require 'spec_helper'

describe I18n::Backend::CachedKeyValueStore do
  let(:store) { {} }
  subject { I18n::Backend::CachedKeyValueStore.new(store) }

  describe '#ensure_freshness!' do
    context 'with expired locale' do
      before do
        store['i18n:locale_version:en'] = '2'
      end

      it 'calls reset_memoizations!' do
        subject.should_receive(:reset_memoizations!).with(:en)
        subject.ensure_freshness! :en
      end

      it 'updates last_locale' do
        subject.ensure_freshness! :en
        subject.last_version.should == { en: '2' }
      end
    end

    context 'with current locale' do
      before do
        store['i18n:locale_version:en'] = '1'
        subject.last_version[:en] = '1'
      end

      it 'does not call reset_memoizations!' do
        subject.should_not_receive(:reset_memoizations!)
        subject.ensure_freshness! :en
      end

      it 'maintains last_locale' do
        subject.ensure_freshness! :en
        subject.last_version.should == { en: '1' }
      end
    end
  end

  describe 'store_translations' do
    before do
      store['i18n:locale_version:en'] = '2'
    end

    it 'updates and dememoizes' do
      subject.should_receive(:reset_memoizations!).with(:en)
      subject.store_translations(:en, {simple: 'test'})
      subject.current_version(:en).should_not ==  '2'
      store['en.simple'].should match(/test/)
    end
  end
end
