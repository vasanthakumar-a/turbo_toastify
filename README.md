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

## Usage

Simply add the `<%= turbo_toastify %>` tag to your layout file `app/views/layouts/application.html.erb`. You do **not** need to install any JavaScript or CSS manually.

```erb
<body>
  <%= yield %>
  <%= turbo_toastify %>
</body>
```

Then, assign ordinary flash messages in your controllers to trigger toasts:

```ruby
def create
  @post = Post.create!(post_params)
  redirect_to posts_path, success: "Post created successfully!"
end
```

If you are using Turbo Streams:

```ruby
def update
  @post.update!(post_params)
  flash.now[:success] = "Updated successfully!"
  respond_to do |format|
    format.turbo_stream
  end
end
```

## Configuration

### Global Defaults

You can configure global defaults in the generated initializer file `config/initializers/turbo_toastify.rb`:

```ruby
Rails.application.config.turbo_toastify = {
  position: "top-right",     # top-right, top-left, top-center, bottom-right, bottom-left, bottom-center
  auto_close: 5000,          # duration in milliseconds
  theme: "light",            # light, dark, colored
  transition: "slide",       # slide, bounce, zoom, flip, fade
  close_button: true,        # true, false
  pause_on_hover: true,      # true, false
  draggable: true            # true, false
}
```

### Per-Request Overrides

You can also customize the toast behaviors on a per-request basis by setting these specific `flash` keys in your controllers:

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `flash[:toast_position]` | `String` | `"top-right"` | Position of the toast (`top-right`, `top-left`, `top-center`, `bottom-right`, `bottom-left`, `bottom-center`). |
| `flash[:toast_duration]` | `Integer` | `5000` | Duration in milliseconds before the toast auto-closes. |
| `flash[:toast_theme]` | `String` | `"light"` | Visual theme of the toast (`light`, `dark`, or `colored`). |
| `flash[:toast_transition]` | `String` | `"slide"` | Animation type (`slide`, `zoom`, `flip`, `bounce`). |
| `flash[:toast_close_button]`| `Boolean` | `true` | Show or hide the close button. |
| `flash[:toast_pause_on_hover]`| `Boolean` | `true` | Pause auto-closing when the mouse hovers over the toast. |
| `flash[:toast_draggable]` | `Boolean` | `true` | Allow the toast to be dragged to close. |

### Example Images

<img width="346" height="85" alt="Light Theme Example" src="https://github.com/user-attachments/assets/b7a3123a-89a3-4f49-97ff-aa25f4b870d0" />

<img width="338" height="87" alt="Dark Theme Example" src="https://github.com/user-attachments/assets/65671ac6-91d7-471f-9c03-6458023f3ae2" />

<img width="339" height="83" alt="Colored Theme Example" src="https://github.com/user-attachments/assets/1c99ffdb-dc3c-4fef-aa16-b7eff08e0cde" />

## JavaScript usage

TurboToastify exposes a global object if you wish to trigger toasts manually from your JavaScript code:

```javascript
TurboToastify.success("Saved!")
TurboToastify.error("Failed to save", { autoClose: 8000, theme: "colored" })
TurboToastify.info("Syncing...", { position: "bottom-center", transition: "zoom" })
TurboToastify.warning("Low storage", { theme: "dark", transition: "flip" })
```

### JavaScript Configuration Options

When calling the JavaScript methods (e.g., `TurboToastify.success()`, `TurboToastify.show()`), you can pass an `options` object as the second argument with the following properties:

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `position` | `String` | `"top-right"` | Position of the toast (`top-right`, `top-left`, `top-center`, `bottom-right`, `bottom-left`, `bottom-center`). |
| `autoClose` | `Number` | `5000` | Duration in milliseconds before the toast auto-closes. |
| `theme` | `String` | `"light"` | Visual theme of the toast (`light`, `dark`, or `colored`). |
| `transition` | `String` | `"slide"` | Animation type (`slide`, `zoom`, `flip`, `bounce`). |
| `closeButton` | `Boolean` | `true` | Show or hide the close button. |
| `pauseOnHover` | `Boolean` | `true` | Pause auto-closing when the mouse hovers over the toast. |
| `draggable` | `Boolean` | `true` | Allow the toast to be dragged to close. |
| `type` | `String` | `"default"` | Toast styling type (`success`, `error`, `warning`, `info`, `default`). Automatically applied when using helper methods like `.success()`. |
