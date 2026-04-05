# TurboToastify

`turbo-toastify` packages a lightweight toast notification system for Rails applications using Turbo + Stimulus.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "turbo-toastify"
```

Then run:

```bash
bundle install
bin/rails generate turbo_toastify:install
```

## What the installer adds

- `app/javascript/toastify/index.js` (core toast engine)
- `app/javascript/controllers/toast_controller.js` (Stimulus bridge)
- `app/assets/stylesheets/turbo_toastify/toastify.css`
- `app/views/shared/_flash.html.erb`
- `config/initializers/turbo_toastify.rb`

It also attempts to:

- insert a permanent Turbo flash outlet in `app/views/layouts/application.html.erb`
- include `<%= stylesheet_link_tag "toastify", "data-turbo-track": "reload" %>` in your layout
- add an importmap pin for `toastify/index` when `config/importmap.rb` is present

## Layout requirements

Make sure your layout includes:

```erb
<div id="flash-outlet"></div>
<%= render "shared/flash" %>
```

## Controller usage

```ruby
def create
  @post = Post.create!(post_params)
  redirect_to posts_path, notice: "Post created successfully!"
end

def update
  @post.update!(post_params)
  respond_to do |format|
    format.turbo_stream do
      render turbo_stream: [
        turbo_stream.replace(@post),
        turbo_stream.append("flash-outlet", partial: "shared/flash")
      ]
    end
  end
end
```

## JavaScript usage

```javascript
TurboToastify.success("Saved!")
TurboToastify.error("Failed to save", { autoClose: 8000, theme: "colored" })
TurboToastify.info("Syncing...", { position: "bottom-center", transition: "zoom" })
TurboToastify.warning("Low storage", { theme: "dark", transition: "flip" })
```
