require 'acceptance/acceptance_helper'

feature 'Entry viewer' do

  shared_examples_for 'a viewer without voting controls' do
    scenario 'do not see the voting controls' do
      (1..5).to_a.each { |i| page.should have_no_field i.to_s }
      page.should have_no_button 'Vote'
    end
  end

  shared_examples_for 'a viewer with hidden contestant names' do
    it 'should not show the contestant name' do
      page.should have_no_link 'charlie'
      body.should_not include 'href="/users/charlie"'
    end
  end

  shared_examples_for 'a viewer with visible contestant names' do
    it 'should show the contestant name' do
      page.should have_link 'charlie'
      body.should include 'href="/users/charlie"'
    end
  end
  
  shared_examples_for 'a viewer with visible comments' do
    scenario 'see the comments' do
      page.should have_css('li#comments')
    end
  end

  shared_examples_for 'a viewer with hidden comments' do
    scenario 'do not see the comments' do
      page.should have_no_css('li#comments')
    end
  end

  background do
    @contest = Fabricate(
      :contest,
      :entries => [
        Fabricate.build(
          :entry,
          :files => {
            'README*markdown' => {'content' => 'This is the _README_ file'},
            'implementation*rb' => { 'content' => 'def foo; bar + baz; end'}
          }
        ),
        Fabricate.build(
          :entry,
          :files => {
            'README*markdown' => {'content' => 'This is the second _README_ file'},
            'implementation*rb' => { 'content' => 'def baz; bar + foo; end'}
          }
        )
      ],
      :starting_on => Date.yesterday.to_time
    )   
  end
  
  scenario 'get a not found error' do
    lambda {
       visit "contests/#{@contest.slug}/entries/#{@contest.entries.first.id}"
    }.should raise_error(ActionController::RoutingError)
  end

  context 'when the contest is open for voting' do

    background do
      # TODO: stub `Contest#state` instead of overwriting the voting and
      # closing dates.

      @contest.update_attributes(:voting_on => Date.yesterday.to_time)
      visit "contests/#{@contest.slug}/entries/#{@contest.entries.first.id}"
    end
    
    it_should_behave_like 'a viewer with hidden contestant names'
    
    it_should_behave_like 'a viewer with hidden comments'
    
    scenario 'see entry files' do
      page.should have_content 'This is the README file'
      page.should have_content 'def foo; bar + baz; end'
    end

    scenario 'parse the entry files using Gust' do
      body.should include '<em>README</em>'
    end

    scenario 'see entry filenames' do
      within('ul#files') { page.should have_content 'README.markdown' }
    end

    scenario 'do not see the "previous" link' do
      page.should have_no_content 'previous'
    end

    scenario 'navigate to the next entry' do
      click_link 'next'
      page.should have_content 'This is the second README file'
      page.should have_content 'def baz; bar + foo; end'
    end
    
    context 'when on the second entry page' do
      background do
        visit "contests/#{@contest.slug}/entries/#{@contest.entries.last.id}"
      end

      scenario 'do not see the "next" link' do
        page.should have_no_content 'next'
      end

      scenario 'navigate to the previous entry' do
        click_link 'previous'
        page.should have_content 'This is the README file'
      end
    end

    context 'when logged in' do

      background { login_via_github }

      it_should_behave_like 'a viewer with hidden comments'

    end

    it_should_behave_like 'a viewer without voting controls'

    it_should_behave_like 'a viewer with hidden contestant names'

    it_should_behave_like 'a viewer with hidden comments'

    context 'when logged in' do

      background { login_via_github }

      scenario 'see the voting controls' do
        (1..5).to_a.each { |i| page.should have_field i.to_s }
        page.should have_button 'Vote'
      end

      it_should_behave_like 'a viewer with hidden comments'

      context 'after voting for the first entry' do

        background do
          choose '3'
          click_button 'Vote'
        end

        scenario 'be taken back to the voted entry' do
          page.should have_content 'This is the README file'
        end

        it_should_behave_like 'a viewer without voting controls'
        
        it_should_behave_like 'a viewer with visible contestant names'
        
        it_should_behave_like 'a viewer with visible comments'
        
        scenario 'add a comment' do
          Gist.expects(:comment).with('866948', 't0k3n', 'Comment!')
          fill_in 'Comment', :with => 'Comment!'
          click_button 'Comment'
        end
        
        it 'should tell me what I voted' do
          page.should have_content 'You voted 3/5'
        end  

      end

      context 'after voting for the last entry' do

        background do
          click_link 'next'
          choose '4'
          click_button 'Vote'
        end

        scenario 'be taken back to the last entry' do
          page.should have_no_content 'This is the README file'
          page.should have_content 'This is the second README file'
          page.should have_content 'You voted 4/5'
        end

      end

    end

  end

  context 'when the contest has finished' do
    background do
      # TODO: stub `Contest#state` instead of overwriting the voting and
      # closing dates.

      @contest.update_attributes(:closing_on => Date.yesterday.to_time)
      visit "contests/#{@contest.slug}/entries/#{@contest.entries.first.id}"
    end

    it_should_behave_like 'a viewer with visible contestant names'
    
    it_should_behave_like 'a viewer with visible comments'
    
    scenario 'do not see the comment box' do
      page.should have_content 'Please log in to comment'
      page.should have_link 'log in'
      body.should include '<a href="/auth/github"'
      page.should have_no_css('textarea')
    end
    
    context 'when logged in' do
      
      background { login_via_github }
      
      scenario 'add a comment' do
        Gist.expects(:comment).with('866948', 't0k3n', 'Comment!')
        fill_in 'Comment', :with => 'Comment!'
        click_button 'Comment'
      end
      
    end

  end

end