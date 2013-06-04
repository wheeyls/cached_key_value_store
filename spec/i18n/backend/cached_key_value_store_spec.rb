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

  describe '#update_version!' do
    it 'writes a timestamp to the store' do
      Time.should_receive(:now).and_return '123'
      key = 'i18n:locale_version:en'

      subject.update_version!(:en)
      store[key].should == 123
    end

    it 'triggers a hook' do
      subject.should_receive(:on_update_version).with :en
      subject.update_version!(:en)
    end
  end

  describe '#on_update_version' do
    context 'with a block' do
      before do
        @prc = Proc.new { }
        subject.on_update_version &@prc
      end

      it 'stores a block you pass to it' do
        @prc.should_not_receive(:call)
        subject.on_update_version { }
      end

      it 'triggers the block if no block is passed' do
        @prc.should_receive(:call).with :en
        subject.on_update_version :en
      end
    end

    context 'without a block' do
      it 'does nothing if no block is passed' do
        expect {
          subject.on_update_version
        }.to_not raise_error
      end
    end
  end
end
